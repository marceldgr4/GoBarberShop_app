import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Bienvenido a la Barbería")
                    .font(.largeTitle)
                    .padding()

                NavigationLink(destination: ReservationView()) {
                    Text("Hacer una Reserva")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
                
                NavigationLink(destination: PerfilView()) {
                    Text("Ver Perfil")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                }
                .padding()

                Spacer()
            }
            .navigationTitle("Home")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
