import SwiftUI

struct RebookReservationView: View {
    @EnvironmentObject var viewModel: ReservationViewModel
    var reservation: Reservation
    
    @State private var selectedDate: Date = Date()
    @State private var selectedTimeSlot: String?
    @State private var showCancelConfirmation = false

    var body: some View {
        Form {
            Section(header: Text("Detalles de la Reserva")) {
                Text("Service: \(reservation.serviceName)")
                Text("BarberShop:\(reservation.barberShopName)")
                Text("Barbero: \(reservation.barberName)")
                Text("Fecha Original: \(reservation.date, formatter: DateFormatter.shortDate)")
                Text("Hora Original: \(reservation.timeSlot)")
                Text("Estado: \(reservation.status.rawValue.capitalized)")
            }
            
            Section(header: Text("Seleccionar Nueva Fecha")) {
                DatePicker("Fecha", selection: $selectedDate, displayedComponents: .date)
            }
            
            Section(header: Text("Seleccionar Nueva Hora")) {
                Picker("Hora", selection: $selectedTimeSlot) {
                    Text("Selecciona una hora").tag(nil as String?)
                    ForEach(viewModel.availableTimeSlots, id: \.self) { timeSlot in
                        Text(timeSlot).tag(timeSlot as String?)
                    }
                }
                .onChange(of: selectedDate) { newDate in
                    Task {
                        await viewModel.fetchAvailableTimeSlots(for: reservation.barberId, on: newDate)
                    }
                }
            }
            
            Button(action: {
                guard let timeSlot = selectedTimeSlot else { return }
                Task {
                    await viewModel.rebookReservation(reservation: reservation, newDate: selectedDate, newTimeSlot: timeSlot)
                }
            }) {
                Text("Reprogramar")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .disabled(selectedTimeSlot == nil)
            
            if reservation.status == .Activo {
                Button(action: {
                    showCancelConfirmation = true
                }) {
                    Text("Cancelar Reserva")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .alert(isPresented: $showCancelConfirmation) {
                    Alert(
                        title: Text("Confirmación"),
                        message: Text("¿Estás seguro de que deseas cancelar esta reserva?"),
                        primaryButton: .destructive(Text("Sí")) {
                            Task {
                                await viewModel.cancelReservation(reservation: reservation)
                            }
                        },
                        secondaryButton: .cancel(Text("No"))
                    )
                }
            }
        }
        .navigationTitle("Reprogramar Reserva")
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Notificación"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
        }
        .onAppear {
            Task {
                await viewModel.fetchAvailableTimeSlots(for: reservation.barberId, on: selectedDate)
            }
        }
    }
}

struct RebookReservationView_Previews: PreviewProvider {
    static var previews: some View {
        RebookReservationView(reservation: Reservation(id: "123", userId: "user123", barberShopId: "barberShop123", barberId: "barber123", serviceId: "service123", date: Date(), status: .Activo, timeSlot: "10:00 AM",barberShopName:"elbarber",serviceName:"complet", barberName: "juan"))
            .environmentObject(ReservationViewModel())
    }
}
