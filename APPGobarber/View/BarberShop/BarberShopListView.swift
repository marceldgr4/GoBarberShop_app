//
//  BarberiaView.swift
//  APPGobarber
//
//  Created by MARCEL DIAZ GRANADOS ROBAYO on 4/06/24.
//

import SwiftUI
//import Kingfisher

struct BarberShopListView: View {
    @EnvironmentObject var viewModel: ReservationViewModel
    
    var body: some View {
        NavigationView {
            List(viewModel.barbershops) { barbershop in
                           NavigationLink(destination: BarbershopDetailView(barbershop: barbershop)) {
                               Text(barbershop.name)
                           }
                       }
                       .navigationTitle("Barberías")
                       .onAppear {
                           Task {
                               await viewModel.fetchBarbershops()
                           }
                       }
                    
                }
            }
        }
    

struct BarberShopListView_Previews: PreviewProvider {
    static var previews: some View {
        BarberShopListView()
            .environmentObject(ReservationViewModel())
    }
}
