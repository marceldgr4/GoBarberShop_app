//
//  authenticationViewModel.swift
//  Barber
//
//  Created by MARCEL DIAZ GRANADOS ROBAYO on 26/03/24.

import Foundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestore
import FirebaseAuth

protocol AuthenticationFormProtocol{
    var formIsValid: Bool {get}
}

@MainActor
class AuthViewModel: ObservableObject{
    @Published var userSession : FirebaseAuth.User?
    @Published var currentUser:User?
    
    init(){
        self.userSession = Auth.auth().currentUser
        Task{
            await fetchUser()
        }
    }
    func CreateUser(Name: String, firstName: String, withEmail email: String, password: String) async throws{
        do{
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, name: Name, firstName: firstName, email: email, userType: "Usuario Normal")
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            await fetchUser()
            
        }catch{
            print("DEBUG: Failed to create user with error\(error.localizedDescription)")
            
        }
    }
    
    func signIn(email:String, password:String) async throws{
        do{
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
        }catch{
            print("DEBUG: Failed to Log user with error\(error.localizedDescription)")
        }
        
    }
    
    func signOut(){
        do{
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
        }
        catch{
            print("Error al salir de sesion: \(error.localizedDescription)")
            
        }
    }
    
    func fetchUser() async {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
            self.currentUser = try? snapshot.data(as: User.self)
        }
        
        func updateUser(name: String?, firstName: String?, phone: String?, address: String?) async throws {
            guard let uid = userSession?.uid else { return }
            guard var currentUser = currentUser else { return }
            
            currentUser.name = name ?? currentUser.name
            currentUser.firstName = firstName ?? currentUser.firstName
            currentUser.phone = phone
            currentUser.address = address
            
            let encodedUser = try Firestore.Encoder().encode(currentUser)
            try await Firestore.firestore().collection("users").document(uid).setData(encodedUser)
            
            self.currentUser = currentUser
        }
    }

    
    
    



