import SwiftUI

struct PerfilView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var isEditing = false
    @State private var name = ""
    @State private var firstName = ""
    @State private var phone = ""
    @State private var address = ""

    var body: some View {
        if let user = viewModel.currentUser {
            List {
                Section {
                    HStack {
                        Text(user.initials)
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(width: 72, height: 72)
                            .background(Color(.systemGray3))
                            .clipShape(Circle())
                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(user.firstName) \(user.name)")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .padding(.top, 4)
                            
                            Text(user.email)
                                .font(.footnote)
                                .accentColor(.gray)
                        }
                    }
                }

                Section("Información Personal") {
                    if isEditing {
                        TextField("Apellido", text: $firstName)
                        TextField("Nombre", text: $name)
                        TextField("Teléfono", text: $phone)
                        TextField("Dirección", text: $address)
                        Button("Guardar") {
                            Task {
                                try await viewModel.updateUser(name: name, firstName: firstName, phone: phone, address: address)
                                isEditing = false
                            }
                        }
                    } else {
                        HStack {
                            Text("Nombre")
                            Spacer()
                            Text(user.firstName)
                                .foregroundColor(.gray)
                        }
                        HStack {
                            Text("Apellido")
                            Spacer()
                            Text(user.name)
                                .foregroundColor(.gray)
                        }
                        HStack {
                            Text("Teléfono")
                            Spacer()
                            Text(user.phone ?? "No especificado")
                                .foregroundColor(.gray)
                        }
                        HStack {
                            Text("Dirección")
                            Spacer()
                            Text(user.address ?? "No especificado")
                                .foregroundColor(.gray)
                        }
                        Button("Editar") {
                            name = user.name
                            firstName = user.firstName
                            phone = user.phone ?? ""
                            address = user.address ?? ""
                            isEditing = true
                        }
                    }
                }

                Section("General") {
                    HStack {
                        SettingRowView(imagenName: "gear",
                                       title: "Versión",
                                       tintColor: Color(.systemGray))
                        Spacer()
                        Text("1.0.0")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }

                Section("Cuenta") {
                    Button {
                        viewModel.signOut()
                        print("Cerrar sesión..")
                    } label: {
                        SettingRowView(imagenName: "arrow.left.circle.fill",
                                       title: "Cerrar sesión",
                                       tintColor: .red)
                    }
                    
                    Button {
                        print("Eliminar cuenta ..")
                    } label: {
                        SettingRowView(imagenName: "xmark.circle.fill",
                                       title: "Eliminar cuenta",
                                       tintColor: .red)
                    }
                }
            }
            .navigationTitle("Perfil")
        }
    }
}

struct PerfilView_Previews: PreviewProvider {
    static var previews: some View {
        PerfilView()
            .environmentObject(AuthViewModel())
    }
}
