//
//  UserService.swift
//  APPGobarber
//
//  Created by MARCEL DIAZ GRANADOS ROBAYO on 23/05/24.
//

import Foundation
import FirebaseFirestore

class UserService{
    private let db = Firestore.firestore()
    
    func createUser(user:User, completion: @escaping(Error?)->Void){
        db.collection("usuarios").document(user.id).setData([
            "name":user.name,
            "fitstName":user.firstName,
            "email":user.email,
            "userType":user.userType
        
        ]){error in completion(error)}
        
    }
}
