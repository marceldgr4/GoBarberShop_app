//
//  Reservation.swift
//  APPGobarber
//
//  Created by MARCEL DIAZ GRANADOS ROBAYO on 24/05/24.
//

import Foundation
import FirebaseFirestoreSwift

struct Reservation: Identifiable, Codable{
    @DocumentID var id: String?
    let userId: String
    let barberShopId:String
    let barberId: String
    let serviceId: String
    let date:Date
    let timeSlot: String
}