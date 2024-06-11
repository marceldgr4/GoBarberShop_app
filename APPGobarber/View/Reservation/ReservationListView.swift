//
//  ReservationListView.swift
//  APPGobarber
//
//  Created by MARCEL DIAZ GRANADOS ROBAYO on 2/06/24.
//

import SwiftUI

struct ReservationListView: View {
    @EnvironmentObject var viewModel: ReservationViewModel
    var body: some View {
        NavigationView {
                    List {
                        ForEach(viewModel.userReservations) { reservation in
                            VStack(alignment: .leading) {
                                
                                Text("Service: \(reservation.serviceName)")
                                Text("BarberShop:\(reservation.barberShopName)")
                                Text("Barbero: \(reservation.barberName)")
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
                                    
                                    // Cancel button
                                    Button(action: {
                                        Task {
                                            await viewModel.cancelReservation(reservation: reservation)
                                        }
                                    }) {
                                        Text("Cancel")
                                            .foregroundColor(.red)
                                    }
                                    .disabled(Date().addingTimeInterval(3600) > reservation.date) // Disable if less than an hour to reservation
                                } else if reservation.status == .CanceladoPorUser || reservation.status == .Cancelado {
                                    Text("Reserva cancelada")
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                }
                .navigationTitle("Reservations")
                .onAppear {
                    Task {
                        await viewModel.fetchUserReservations()
                    }
                }
                .alert(isPresented: $viewModel.showAlert) {
                    Alert(title: Text("Notification"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
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
