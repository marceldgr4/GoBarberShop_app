//
//  BarberShopViewModel.swift
//  APPGobarber
//
//  Created by MARCEL DIAZ GRANADOS ROBAYO on 7/06/24.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
@MainActor
class BarberShopViewModel: ObservableObject {
    @Published var barbershops: [BarberShop] = []
    @Published var barbers: [Barber] = []
    
    private let db = Firestore.firestore()
    
    init() {
        Task {
            await fetchBarbershops()
        }
    }
    
    func fetchBarbershops() async {
        do {
            let snapshot = try await db.collection("BarberShops Collection").getDocuments()
            self.barbershops = snapshot.documents.compactMap { try? $0.data(as: BarberShop.self) }
        } catch {
            print("Error fetching barbershops: \(error)")
        }
    }
    
    func fetchBarbers(for barbershopId: String) async {
        do {
            let snapshot = try await db.collection("Barbers Collection")
                .whereField("barbershopId", isEqualTo: barbershopId)
                .getDocuments()
            self.barbers = snapshot.documents.compactMap { try? $0.data(as: Barber.self) }
        } catch {
            print("Error fetching barbers: \(error)")
        }
    }
}
