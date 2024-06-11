//
//  BarbershopDetailView.swift
//  APPGobarber
//
//  Created by MARCEL DIAZ GRANADOS ROBAYO on 4/06/24.
//

import SwiftUI

struct BarbershopDetailView: View {
    @EnvironmentObject var viewModel: ReservationViewModel
    let barbershop: BarberShop
    @State private var barbers: [Barber] = []
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if let imageUrl = barbershop.imageUrl, let url = URL(string: imageUrl) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)
                        .cornerRadius(10)
                } placeholder: {
                    ProgressView()
                }
                .padding(.bottom, 10)
            }
                    
            Text(barbershop.name)
                .font(.largeTitle)
                .padding(.bottom, 10)
            //agregar mas campos para el detalle
            Text("Dirección: \(barbershop.address)")
                .font(.body)
            
            
            
            Text("Location: \(barbershop.location)")
                .font(.body)
            
            Text("Barberos:")
                .font(.title2)
                .padding(.top, 10)
            
            List(barbers) { barber in
                HStack {
                    AsyncImage(url: URL(string: barber.profileImageUrl!)) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 90, height: 90)
                                .clipShape(Circle())
                        case .failure:
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 90, height: 90)
                        @unknown default:
                            EmptyView()
                        }
                    }
                    Text(barber.name)
                }
                Spacer()
            }
            .padding()
            .navigationTitle("Detalles de la Barbería")
            .onAppear {
                Task {
                    await viewModel.fetchBarbers(barbershopId: barbershop.id!)
                    barbers = viewModel.barbers
                }
            }
        }
    }
}

struct BarbershopDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleBarbershop = BarberShop(id: "1", name: "Barbería Ejemplo", address: "Calle Falsa 123", location: "santa marta", imageUrl: "img",hours: "9 AM - 5 PM", latitude: "0.0", longitude: "0.0")
        BarbershopDetailView(barbershop: sampleBarbershop)
    }
}
