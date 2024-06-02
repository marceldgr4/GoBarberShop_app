//
//  RegistrationView.swift
//  APPGobarber
//
//  Created by MARCEL DIAZ GRANADOS ROBAYO on 23/05/24.
//

import SwiftUI

struct RegistrationView: View {
    @State private var email = ""
    @State private var name = ""
    @State private var firstName = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isUserCreated = false
       
       
       
       @Environment(\.dismiss)var dismiss
       @EnvironmentObject var viewModel: AuthViewModel

       var body: some View {
           VStack{
               Image("logo2")//para cambiar imagen
                   .resizable()
                   .scaledToFill()
                   .frame(width: 380, height: 100)
                   .padding(.vertical, 32)
               
                  
               Spacer()
               VStack(spacing: 50) {
                   Spacer()
                    //agregar titulo
                   Text("REGISTER")
                       .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                       .bold()
               }
           
               
               
               VStack(spacing: 25) {
                                   
                   InputView(text: $name,
                            title: "Name",
                            placeholder: "name")
                           
                   InputView(text: $firstName,
                             title: "first Name",
                             placeholder: "fistName")
                   
                   InputView(text: $email,
                             title: "Email address",
                             placeholder: "Name@exmaple.com")
                       .autocapitalization(.none)
                                  
                   
                   InputView(text: $password,
                             title: "password",
                             placeholder: "entre yoru password",
                             isSecureField: true)
                   
                   ZStack(alignment: .trailing){
                       InputView(text: $confirmPassword,
                                 title: "confirmPassword",
                                 placeholder: "Confirm your Password",
                                 isSecureField: true)
                       if !password.isEmpty && !confirmPassword.isEmpty{
                           if password == confirmPassword{
                               Image(systemName: "checkmark.circle.fill")
                                   .imageScale(.large)
                                   .fontWeight(.bold)
                                   .foregroundColor(Color(.systemGreen))
                           }else{
                               Image(systemName: "xmark.circle.fill")
                                   .imageScale(.large)
                                   .fontWeight(.bold)
                                   .foregroundColor(Color(.systemRed))
                               
                           }
                       }
                   }
                   
                   
               }
               .padding(.horizontal)
               .padding(.top,12)

              
               Button {
                   Task {
                       try await viewModel.CreateUser(Name: name,
                                                      firstName: firstName,
                                                      withEmail: email,
                                                      password: password)
                       isUserCreated = true
                      
                   }
                   print("Resgitrar Usuario..")
               }label: {
                   HStack{
                   Text("Sing up")
                      .fontWeight(.semibold)
                       Image(systemName: "arrow.right")
               }
               .foregroundColor(.white)
               .frame(width: UIScreen.main.bounds.width - 32, height: 48)
               
           }
           .background(Color(.systemBlue))
           .disabled(!formIsValid)
           .opacity(formIsValid ? 1.0: 0.5)
           .cornerRadius(10)
           .padding(.top,24)
               
               Spacer()
               
               Button{
                   dismiss()
                   
               }label: {
                   HStack(spacing: 3){
                     Text("¿Ya tienes una cuenta?")
                     Text("Iniciar sesión")
                       .fontWeight(.bold)
               }
               .font(.system(size:14))
               }
            }
           .fullScreenCover(isPresented: $isUserCreated){
               HomeView()
           }
        }
    }
   extension RegistrationView: AuthenticationFormProtocol {
       var formIsValid:Bool{
           return !email.isEmpty
           && email.contains("@")
           && !password.isEmpty
           && password.count>6
           && confirmPassword == password
           && !name.isEmpty
           && !firstName.isEmpty
         
           
       }
   }

   struct RegistrationView_Previews: PreviewProvider{
       static var previews: some View{
           RegistrationView()
               .environmentObject(AuthViewModel())
       }
   }
