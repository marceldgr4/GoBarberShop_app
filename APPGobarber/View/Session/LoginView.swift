import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var isLoggedIn = false

    var body: some View {
        NavigationStack {
            VStack {
                // imagen
                Image("logo2")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 380, height: 100)
                    .padding(.vertical, 32)

                Spacer()

                VStack(spacing: 20) {
                    Text("LOGIN")
                        .font(.title)
                        .bold()
                }

                // form fields
                VStack(spacing: 25) {
                    InputView(text: $email,
                              title: "Email address",
                              placeholder: "name@example.com")
                        .autocapitalization(.none)

                    InputView(text: $password,
                              title: "Password",
                              placeholder: "Enter your password",
                              isSecureField: true)
                }
                .padding(.horizontal)
                .padding(.top, 12)

                // sign in button
                Button {
                    Task {
                        do {
                            try await viewModel.signIn(email: email, password: password)
                            isLoggedIn = true
                        } catch {
                            print("Failed to log user in: \(error.localizedDescription)")
                        }
                    }
                } label: {
                    HStack {
                        Text("Sign in")
                            .fontWeight(.semibold)
                        Image(systemName: "arrow.right")
                    }
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                }
                .background(Color(.systemBlue))
                .disabled(!formIsValid)
                .opacity(formIsValid ? 1.0 : 0.5)
                .cornerRadius(10)
                .padding(.top, 24)

                // Botón de recuperación de contraseña
                NavigationLink(destination: PasswordRecoveryView()) {
                    Text("Olvidé mi contraseña")
                        .foregroundColor(.blue)
                        .padding(.top, 8)
                }

                Spacer()

                // sign up button
                NavigationLink {
                    RegistrationView()
                        .navigationBarBackButtonHidden(true)
                } label: {
                    HStack(spacing: 3) {
                        Text("Don't have an account?")
                        Text("Sign up")
                            .fontWeight(.bold)
                    }
                    .font(.system(size: 14))
                }

                // Navigate to HomeView when logged in
                NavigationLink(destination: HomeView().navigationBarBackButtonHidden(true), isActive: $isLoggedIn) {
                    EmptyView()
                }
            }
        }
    }
}

extension LoginView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
            && email.contains("@")
            && !password.isEmpty
            && password.count > 6
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(AuthViewModel())
    }
}
