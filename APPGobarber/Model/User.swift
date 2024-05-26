//
//  user.swift
//  GobarberApp
//
//  Created by MARCEL DIAZ GRANADOS ROBAYO on 12/05/24.
//

import Foundation

struct User: Identifiable, Codable {
    let id: String
    let name: String
    let firstName: String
    let email: String
    //let role: UserRole?
   /*
    enum UserRole: String, Codable {
        case Admin
        case barber
        case user
    }
    
    init(id: String, name: String, firstName: String, email: String? = nil, role: UserRole? = nil) {
        self.id = id
        self.email = email
        self.name = name
        self.firstName = firstName
        self.role = role
    }*/
    
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
    static var MOCK_USER = User(id: NSUUID().uuidString, name: "Name", firstName: "FirstName", email: "example@email.com")
}
