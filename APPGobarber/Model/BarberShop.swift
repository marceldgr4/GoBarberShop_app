//
//  BarberShop.swift
//  APPGobarber
//
//  Created by MARCEL DIAZ GRANADOS ROBAYO on 24/05/24.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore
struct BarberShop: Identifiable, Codable, Hashable{
    @DocumentID var id: String?
    let name: String
    let address: String
    
    func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
        
        static func ==(lhs: BarberShop, rhs: BarberShop) -> Bool {
            return lhs.id == rhs.id
        }
    }
