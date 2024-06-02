//
//  ReservationListView.swift
//  APPGobarber
//
//  Created by MARCEL DIAZ GRANADOS ROBAYO on 2/06/24.
//

import SwiftUI

struct ReservationListView: View {
    @EnvironmentObject var ViewModel: ReservationViewModel
    var body: some View {
    NavigationView {
                List {
                    ForEach(ViewModel.reservations) { reservation in
                        VStack(alignment: .leading) {
                            Text("Service: \(reservation.serviceId)")
                            Text("Date: \(reservation.date, formatter: DateFormatter.shortDate)")
                            Text("Time: \(reservation.timeSlot)")
                            Text("Status: \(reservation.status.rawValue.capitalized)")
                            
                            HStack {
                                // Rebook button
                                if reservation.status == .Activo {
                                    NavigationLink(destination: RebookReservationView(reservation: reservation)) {
                                        Text("Modify")
                                            .foregroundColor(.blue)
                                    }
                                }

                            // Cancel button
                            Button(action: {
                                Task {
                                    await ViewModel.cancelReservation(reservation: reservation)
                                }
                            }) {
                                Text("Cancel")
                                    .foregroundColor(.red)
                            }
                            .disabled(Date().addingTimeInterval(3600) > reservation.date) // Disable if less than an hour to reservation
                        }
                    }
                }
            }
            .navigationTitle("Reservations")
            .onAppear {
                Task {
                    await ViewModel.fetchUserReservations()
                }
            }
            .alert(isPresented: $ViewModel.showAlert) {
                Alert(title: Text("Notification"), message: Text(ViewModel.alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
}

struct ReservationListView_Previews: PreviewProvider {
    static var previews: some View {
        ReservationListView()
            .environmentObject(ReservationViewModel())
    }
}
