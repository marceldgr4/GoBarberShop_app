//
//  HistoryView.swift
//  APPGobarber
//
//  Created by MARCEL DIAZ GRANADOS ROBAYO on 2/06/24.
//

import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var viewModel: ReservationViewModel
    
    var body: some View {
        VStack {
                    Text("Historial de Reservas")
                        .font(.largeTitle)
                        .padding()

                    List {
                        Section(header: Text("Reservas Completadas")) {
                            ForEach(viewModel.completedReservations) { reservation in
                                VStack(alignment: .leading) {
                                    Text("Fecha: \(reservation.date, formatter: DateFormatter.shortDate)")
                                    Text("Hora: \(reservation.timeSlot)")
                                    Text("Barbería: \(reservation.barberShopId)")
                                    Text("Barbero: \(reservation.barberId)")
                                }
                            }
                        }

                        Section(header: Text("Reservas Canceladas")) {
                            ForEach(viewModel.cancelledReservations) { reservation in
                                VStack(alignment: .leading) {
                                    Text("Fecha: \(reservation.date, formatter: DateFormatter.shortDate)")
                                    Text("Hora: \(reservation.timeSlot)")
                                    Text("Barbería: \(reservation.barberShopId)")
                                    Text("Barbero: \(reservation.barberId)")
                                }
                            }
                        }
                    }
                }
            }
        }

        

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView().environmentObject(ReservationViewModel())
    }
}
