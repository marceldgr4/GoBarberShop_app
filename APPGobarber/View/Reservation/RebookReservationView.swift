//
//  RebookReservationView.swift
//  APPGobarber
//
//  Created by MARCEL DIAZ GRANADOS ROBAYO on 2/06/24.
//

import SwiftUI

struct RebookReservationView: View {
    @EnvironmentObject var viewModel: ReservationViewModel
    var reservation: Reservation
    
    @State private var selectedDate: Date = Date()
    @State private var selectedTimeSlot: String?
    
    var body: some View {
        Form {
            Section(header: Text("Reservation Details")) {
                Text("Service: \(reservation.serviceId)")
                Text("Original Date: \(reservation.date, formatter: DateFormatter.shortDate)")
                Text("Original Time: \(reservation.timeSlot)")
                Text("Status: \(reservation.status.rawValue.capitalized)")
            }
            
            Section(header: Text("Select New Date")) {
                DatePicker("Date", selection: $selectedDate, displayedComponents: .date)
            }
            
            Section(header: Text("Select New Time Slot")) {
                Picker("Time Slot", selection: $selectedTimeSlot) {
                    Text("Select a time slot").tag(nil as String?)
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
                Text("Rebook")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .disabled(selectedTimeSlot == nil)
        }
        .navigationTitle("Rebook Reservation")
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Notification"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
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
        RebookReservationView(reservation: Reservation(id: "123", userId: "user123", barberShopId: "barberShop123", barberId: "barber123", serviceId: "service123", date: Date(), status: .Activo, timeSlot: "10:00 AM"))
            .environmentObject(ReservationViewModel())
    }
}
