//
//  Service.swift
//  APPGobarber
//
//  Created by MARCEL DIAZ GRANADOS ROBAYO on 24/05/24.
//

import Foundation
import FirebaseFirestoreSwift

struct ServiceBarber: Identifiable, Codable, Hashable{
    @DocumentID var id: String?
    let name: String
    let duration: Int
    
    func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
        
        static func ==(lhs: ServiceBarber, rhs: ServiceBarber) -> Bool {
            return lhs.id == rhs.id
        }
    
}
