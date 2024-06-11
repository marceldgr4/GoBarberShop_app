//
//  BarbersListView.swift
//  APPGobarber
//
//  Created by MARCEL DIAZ GRANADOS ROBAYO on 6/06/24.
//

import SwiftUI

struct BarbersListView: View {
    @EnvironmentObject var viewModel: ReservationViewModel
    @State private var barbers: [Barber] = []
    var body: some View {
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
    }
}

struct BarbersListView_Previews: PreviewProvider {
    static var previews: some View {
        BarbersListView()
            .environmentObject(ReservationViewModel())
    }
}
