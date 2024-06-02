//
//  user.swift
//  GobarberApp
//
//  Created by MARCEL DIAZ GRANADOS ROBAYO on 12/05/24.
//

import Foundation

struct User: Identifiable, Codable {
    let id: String
    var name: String
    var firstName: String
    let email: String
    let userType: String
    var phone: String?
    var address: String?
  
    
    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: name) {
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        return ""
    }
}

extension User {
    static var MOCK_USER = User(id: NSUUID().uuidString, name: "Name", firstName: "FirstName", email: "example@email.com", userType: "Usuario Normal")
}
