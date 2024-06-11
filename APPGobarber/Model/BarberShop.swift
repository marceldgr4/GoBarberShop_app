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
    let location: String
    let imageUrl: String? 
   
    let hours: String
    let latitude: String
    let longitude: String
    
    
   
    }
