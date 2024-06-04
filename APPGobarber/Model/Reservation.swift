//
//  Reservation.swift
//  APPGobarber
//
//  Created by MARCEL DIAZ GRANADOS ROBAYO on 24/05/24.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore
struct Reservation: Identifiable, Codable{
   
    @DocumentID var id: String?
    let userId: String
    let barberShopId:String
    let barberId: String
    let serviceId: String
    let date:Date
    let status: ReservationStatus
    let timeSlot: String
    
    let barberShopName: String
    let serviceName: String
    let barberName:String
    
    enum ReservationStatus: String, Codable {
            case Activo
            case Completado
            case CanceladoPorUser
            case Cancelado
        }
    
   
    
}
