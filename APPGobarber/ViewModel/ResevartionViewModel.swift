//
//  ResevartionViewModel.swift
//  APPGobarber
//
//  Created by MARCEL DIAZ GRANADOS ROBAYO on 24/05/24.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

@MainActor
class ReservationViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var barbershops: [BarberShop] = []
    @Published var barbers: [Barber] = []
    @Published var services: [ServiceBarber] = []
    @Published var availableTimeSlots: [String] = []
   
    @Published var selectedDate: Date = Date()
    @Published var selectedBarbershop: BarberShop?
    @Published var selectedBarber: Barber?
    @Published var selectedServices: ServiceBarber?
    @Published var selectedTime: Date = Date()
    
    @Published var reservations: [Reservation] = []
    @Published var userReservations: [Reservation] = []
    @Published var completedOrCancelledReservations: [Reservation] = []
   
    @Published var alertMessage: String = ""
    @Published var showAlert: Bool = false
    
    //@Published var serviceBarbers: [ServiceBarber] = []
    @Published var isLoading = true
    @Published var error: Error?
    
    private let db = Firestore.firestore()


    init() {
        self.userSession = Auth.auth().currentUser
        Task {
            await fetchUser()
            await loadData()
            await fetchBarbershops()
            await fetchServices()
            await fetchUserReservations()
            await fetchCompletedOrCancelledReservations()
        }
    }
    
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
        self.currentUser = try? snapshot.data(as: User.self)
    }
    func loadData() async {
            await fetchBarbershops()
            await fetchServices()
        }
    
    func fetchBarbershops() async {
            let snapshot = try? await Firestore.firestore().collection("BarberShops Collection").getDocuments()
            self.barbershops = snapshot?.documents.compactMap { try? $0.data(as: BarberShop.self) } ?? []
        }
    
    func fetchBarbers(barbershopId: String) async {
           let barbershopReference = Firestore.firestore().collection("BarberShops Collection").document(barbershopId)
           do {
               let snapshot = try await Firestore.firestore().collection("Barbers Collection")
                   .whereField("barbershopReference", isEqualTo: barbershopReference)
                   .getDocuments()
               self.barbers = snapshot.documents.compactMap { try? $0.data(as: Barber.self) }
           } catch {
               print("Error fetching barbers: \(error.localizedDescription)")
           }
       }
   
    
   
    
    
    func createReservation(barberShop: BarberShop, barber: Barber, service: ServiceBarber, date: Date, timeSlot: String) async {
        guard let userId = userSession?.uid else { return }

        // Verificar si el barbero ya tiene una reserva en el mismo horario
        let snapshot = try? await Firestore.firestore().collection("reservations")
            .whereField("barberId", isEqualTo: barber.id!)
            .whereField("date", isEqualTo: date)
            .whereField("timeSlot", isEqualTo: timeSlot)
            .getDocuments()
        
        if let documents = snapshot?.documents, !documents.isEmpty {
            // El barbero no está disponible en el horario seleccionado
            showAlert = true
            alertMessage = "El barbero no está disponible a esa hora, por favor seleccione otra hora."
            return
        }

        // Verificar el límite de citas para el barbero en este día
        let reservationsSnapshot = try? await Firestore.firestore().collection("reservations")
            .whereField("barberId", isEqualTo: barber.id!)
            .whereField("date", isEqualTo: date)
            .getDocuments()
        
        if let reservationsCount = reservationsSnapshot?.documents.count, reservationsCount >= 10 {
            // El barbero ha alcanzado el límite de citas para este día
            showAlert = true
            alertMessage = "El barbero ha alcanzado el límite de citas para este día. Por favor, seleccione otro día u otro barbero."
            return
        }

        // Crear la reserva si el horario y el límite de citas están disponibles
        let reservation = Reservation(id: UUID().uuidString, userId: userId, 
                                      barberShopId: barberShop.id!,
                                      barberId: barber.id!,
                                      serviceId: service.id!,
                                      date: date, status: .Activo,
                                      timeSlot: timeSlot,
                                      barberShopName: barberShop.name,
                                      serviceName: service.name,
                                      barberName: barber.name)
        if let encodedReservation = try? Firestore.Encoder().encode(reservation) {
            try? await Firestore.firestore().collection("reservations").document(reservation.id!).setData(encodedReservation)
            // Reserva creada con éxito, mostrar mensaje de confirmación
            showAlert = true
            alertMessage = "Tu reserva ha sido creada con éxito."
        } else {
            showAlert = true
            alertMessage = "Error al crear la reserva. Inténtelo de nuevo."
        }
    }
    
    func fetchUserReservations() async {
            guard let userId = userSession?.uid else { return }
            let snapshot = try? await Firestore.firestore().collection("reservations")
                .whereField("userId", isEqualTo: userId)
                .getDocuments()
            
            self.userReservations = snapshot?.documents.compactMap { try? $0.data(as: Reservation.self) } ?? []
        }

    func updateReservationStatus(reservationId: String, status: Reservation.ReservationStatus) async {
            try? await Firestore.firestore().collection("reservations").document(reservationId).updateData(["status": status.rawValue])
            await fetchUserReservations() // refresh reservations
        }
        
        
        
        func canModifyReservation(reservation: Reservation) -> Bool {
            let timeInterval = reservation.date.timeIntervalSince(Date())
            return timeInterval > 3600 // more than 1 hour left
        }
    
    func rebookReservation(reservation: Reservation, newDate: Date, newTimeSlot: String) async {
            guard let userId = userSession?.uid else { return }

            // Verificar si el barbero ya tiene una reserva en el mismo horario
            let snapshot = try? await Firestore.firestore().collection("reservations")
                .whereField("barberId", isEqualTo: reservation.barberId)
                .whereField("date", isEqualTo: newDate)
                .whereField("timeSlot", isEqualTo: newTimeSlot)
                .getDocuments()
            
            if let documents = snapshot?.documents, !documents.isEmpty {
                // El barbero no está disponible en el horario seleccionado
                showAlert = true
                alertMessage = "El barbero no está disponible a esa hora, por favor seleccione otra hora."
                return
            }

            // Actualizar la reserva si el horario está disponible
        let updatedReservation = Reservation(id: reservation.id, 
                                             userId: userId,
                                             barberShopId: reservation.barberShopId,
                                             barberId: reservation.barberId,
                                             serviceId: reservation.serviceId,
                                             date: newDate, status: .Activo,
                                             timeSlot: newTimeSlot,
                                             barberShopName: reservation.barberShopName,
                                             serviceName: reservation.serviceName, 
                                             barberName: reservation.barberName)
            if let encodedReservation = try? Firestore.Encoder().encode(updatedReservation) {
                try? await Firestore.firestore().collection("reservations").document(updatedReservation.id!).setData(encodedReservation)
                // Reserva reprogramada con éxito, mostrar mensaje de confirmación
                showAlert = true
                alertMessage = "Tu reserva ha sido reprogramada con éxito."
                await fetchUserReservations()
            } else {
                showAlert = true
                alertMessage = "Error al reprogramar la reserva. Inténtelo de nuevo."
            }
        }
    
    func fetchCompletedOrCancelledReservations() async {
            guard let userId = userSession?.uid else { return }
            let snapshot = try? await Firestore.firestore().collection("reservations")
                .whereField("userId", isEqualTo: userId)
                .whereField("status", in: ["completed", "cancelled"])
                .getDocuments()
            
            self.completedOrCancelledReservations = snapshot?.documents.compactMap { try? $0.data(as: Reservation.self) } ?? []
        }
    
    func cancelReservation(reservation: Reservation) async {
        let updatedReservation = Reservation(id: reservation.id,
                                             userId: reservation.userId,
                                             barberShopId: reservation.barberShopId,
                                             barberId: reservation.barberId,
                                             serviceId: reservation.serviceId,
                                             date: reservation.date,
                                             status: .CanceladoPorUser,
                                             timeSlot: reservation.timeSlot,
                                             barberShopName: reservation.barberShopName,
                                             serviceName: reservation.serviceName, 
                                             barberName: reservation.barberName)
        if let encodedReservation = try? Firestore.Encoder().encode(updatedReservation) {
            try? await Firestore.firestore().collection("reservations").document(updatedReservation.id!).setData(encodedReservation)
            showAlert = true
            alertMessage = "Tu reserva ha sido cancelada con éxito."
            // Eliminar la reserva cancelada de la lista de reservas del usuario
            userReservations.removeAll { $0.id == reservation.id }
        } else {
            showAlert = true
            alertMessage = "Error al cancelar la reserva. Inténtelo de nuevo."
        }
    }
    
    func fetchAvailableTimeSlots(for barberId: String, on date: Date) async {
        // Fetch all reservations for the barber on the given date
        let snapshot = try? await db.collection("reservations")
            .whereField("barberId", isEqualTo: barberId)
            .whereField("date", isEqualTo: date)
            .getDocuments()

        if let documents = snapshot?.documents {
            let existingReservations = documents.compactMap { try? $0.data(as: Reservation.self) }

            // Calculate the number of reservations for the barber on the given date
            let totalReservations = existingReservations.count

            // Check if the barber has reached the maximum number of reservations (10)
            if totalReservations >= 10 {
                // Barber has reached the maximum number of reservations, return empty array
                availableTimeSlots = []
                alertMessage = "El barbero ha alcanzado el número máximo de reservas para el día de hoy."
                showAlert = true
                return
            }

            // Calculate available time slots
            let allTimeSlots = ["9:00 AM", "10:00 AM", "11:00 AM", "12:00 PM", "1:00 PM", "2:00 PM", "3:00 PM", "4:00 PM", "5:00 PM"]
            let reservedTimeSlots = existingReservations.map { $0.timeSlot }
            availableTimeSlots = allTimeSlots.filter { !reservedTimeSlots.contains($0) }
        }
    }
    var completedReservations: [Reservation] = []
    var cancelledReservations: [Reservation] = []
     
    
    
    
    func addBarber(barber: Barber) {
            do {
                let _ = try Firestore.firestore().collection("Barbers Collection").addDocument(from: barber)
                alertMessage = "Barbero agregado con éxito."
                showAlert = true
            } catch {
                alertMessage = "Error al agregar el barbero: \(error.localizedDescription)"
                showAlert = true
            }
        }
    //----------------------
    func fetchServices() async {
        isLoading = true
            do {
                let snapshot = try await Firestore.firestore().collection("ServiceBarbers Collection").getDocuments()
                print("Fetched \(snapshot.documents.count) services")
                
                self.services = snapshot.documents.compactMap { document in
                    do {
                        let service = try document.data(as: ServiceBarber.self)
                        print("Fetched service: \(service)")
                        return service
                    } catch {
                        print("Error decoding service: \(error)")
                        return nil
                    }
                }
                
                print("Services array: \(self.services)")
            } catch {
                print("Error fetching services: \(error.localizedDescription)")
            }
        }
    //---------------------
    
    
    
    
}
    

