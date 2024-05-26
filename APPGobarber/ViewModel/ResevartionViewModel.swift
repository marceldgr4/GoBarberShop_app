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

    init() {
        self.userSession = Auth.auth().currentUser
        Task {
            await fetchUser()
            await loadData()
            await fetchBarbershops()
            await fetchServices()
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
    
    func fetchServices() async {
            do {
                let snapshot = try await Firestore.firestore().collection("ServiceBarber Collection").getDocuments()
                self.services = snapshot.documents.compactMap { try? $0.data(as: ServiceBarber.self) }
            } catch {
                print("Error fetching services: \(error.localizedDescription)")
            }
        }
    
    func createReservation(barberShop: BarberShop, barber: Barber, service: ServiceBarber, date: Date, timeSlot: String) async {
            guard let userId = userSession?.uid else { return }
            let reservation = Reservation(userId: userId, barberShopId: barberShop.id!, barberId: barber.id!, serviceId: service.id!, date: date, timeSlot: timeSlot)

            do {
                let encodedReservation = try Firestore.Encoder().encode(reservation)
                try await Firestore.firestore().collection("reservations").document().setData(encodedReservation)
            } catch {
                print("Error creating reservation: \(error.localizedDescription)")
            }
        }
    func fetchAvailableTimeSlots(for barberId: String, on date: Date) async {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateString = dateFormatter.string(from: date)

            do {
                let snapshot = try await Firestore.firestore().collection("reservations")
                    .whereField("barberId", isEqualTo: barberId)
                    .whereField("date", isEqualTo: dateString)
                    .getDocuments()

                let reservedTimeSlots = snapshot.documents.compactMap { $0["timeSlot"] as? String }
                let allTimeSlots = ["09:00", "10:00", "11:00", "12:00", "13:00", "14:00", "15:00", "16:00", "17:00"]

                self.availableTimeSlots = allTimeSlots.filter { !reservedTimeSlots.contains($0) }
            } catch {
                print("Error fetching available time slots: \(error.localizedDescription)")
            }
        }

    
    
}
    

