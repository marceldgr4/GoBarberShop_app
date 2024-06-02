//
//  PasswordRecoveryView.swift
//  APPGobarber
//
//  Created by MARCEL DIAZ GRANADOS ROBAYO on 23/05/24.
//

import SwiftUI
import FirebaseAuth

struct PasswordRecoveryView: View {
    @State private var email = ""
    @State private var errorMessage: String?
    @State private var showingAlert = false
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            Image("logo2") // para cambiar imagen
                .resizable()
                .scaledToFill()
                .frame(width: 380, height: 100)
                .padding(.vertical, 32)

            Spacer()

            VStack(spacing: 20) {
                Text("Recuperar Contraseña")
                    .font(.title)
                    .bold()

                InputView(text: $email,
                          title: "Correo Electrónico",
                          placeholder: "name@example.com")
                    .autocapitalization(.none)
            }
            .padding(.horizontal)
            .padding(.top, 12)

            Button {
                sendPasswordReset()
            } label: {
                HStack {
                    Text("Enviar Enlace")
                        .fontWeight(.semibold)
                    Image(systemName: "arrow.right")
                }
                .foregroundColor(.white)
                .frame(width: UIScreen.main.bounds.width - 32, height: 48)
            }
            .background(Color(.systemBlue))
            .cornerRadius(10)
            .padding(.top, 24)
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Recuperación de Contraseña"),
                      message: Text(errorMessage ?? "Se ha enviado un enlace de recuperación a tu correo electrónico."),
                      dismissButton: .default(Text("OK")) {
                          if errorMessage == nil {
                              dismiss()
                          }
                      })
            }

            Spacer()
        }
        .padding()
    }

    func sendPasswordReset() {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                errorMessage = error.localizedDescription
            } else {
                errorMessage = nil
            }
            showingAlert = true
        }
    }
}

struct PasswordRecoveryView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordRecoveryView()
    }
}
