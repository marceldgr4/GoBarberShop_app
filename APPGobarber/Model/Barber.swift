//
//  Barber.swift
//  APPGobarber
//
//  Created by MARCEL DIAZ GRANADOS ROBAYO on 24/05/24.
//

import Foundation
import FirebaseFirestoreSwift

struct Barber: Identifiable, Codable,Hashable{
    @DocumentID var id: String?
    let name: String
    let barbershopId: String
    
    func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
        
        static func ==(lhs: Barber, rhs: Barber) -> Bool {
            return lhs.id == rhs.id
        }
}
