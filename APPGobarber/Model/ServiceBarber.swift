//
//  Service.swift
//  APPGobarber
//
//  Created by MARCEL DIAZ GRANADOS ROBAYO on 24/05/24.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore
struct ServiceBarber: Identifiable, Codable, Hashable{
    @DocumentID var id: String?
    let name: String
    let duration: Int
  
   
    
}
