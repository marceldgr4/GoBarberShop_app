//
//  ContentView.swift
//  APPGobarber
//
//  Created by MARCEL DIAZ GRANADOS ROBAYO on 23/05/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    var body: some View {
        Group{
                   if viewModel.userSession != nil{
                      //PerfilView()// cambiar despues home
                       //ReservationView()
                       HomeView()
                   }else{
                       LoginView()
                   }
               }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthViewModel())
}
