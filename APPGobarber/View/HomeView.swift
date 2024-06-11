import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: ReservationViewModel
    @State private var currentDate = Date()
    @State private var temperature: String = "..."
    @State private var weatherCondition: String = "..."

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                HStack {
                    VStack(alignment: .leading) {
                        if let user = viewModel.currentUser {
                            Text("Hola \(user.name) 👋")
                                .font(.largeTitle)
                                .padding(.leading)
                        } else {
                            Text("Hola 👋")
                                .font(.largeTitle)
                                .padding(.leading)
                        }
                        Text(currentDate, formatter: DateFormatter.shortDate)
                            .font(.headline)
                            .padding(.leading)
                        Text("\(temperature)º \(weatherCondition)")
                            .font(.subheadline)
                            .padding(.leading)
                    }
                    Spacer()
                    HStack(spacing: 10) {
                        Image(systemName: "bell")
                            .font(.title)
                            .padding()
                        NavigationLink(destination: PerfilView()) {
                            Image(systemName: "person.crop.circle")
                                .font(.title)
                                .padding()
                        }
                    }
                    .padding(.trailing)
                }
                
                Spacer().frame(height: 40)
                
                ScrollView {
                    VStack(spacing: 40) {
                        HStack(spacing: 40) {
                            ServiceCardView(serviceName: "Cortar", imageName: "img11")
                            ServiceCardView(serviceName: "Afeitar", imageName: "img12")
                        }
                        HStack(spacing: 40) {
                            NavigationLink(destination: BarberShopListView()) {
                                                           ServiceCardView(serviceName: "BarbaShopList", imageName: "img1")
                                                       }
                            
                            NavigationLink(destination: ReservationListView()) {
                                                            ServiceCardView(serviceName: "Mis Reservas", imageName: "img2")
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
                
                HStack {
                    NavigationLink(destination: ReservationView()) {
                        VStack {
                            Image(systemName: "calendar")
                            Text("Reservar")
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding()
                .background(Color(UIColor.systemGray6))
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            viewModel.currentUser // Fetch user details
            updateWeather()
        }
    }
    
    private func updateWeather() {
        // Aquí llamas a la API de clima y actualizas los valores de temperatura y weatherCondition
        // Para simplicidad, aquí se muestra un ejemplo estático
        self.temperature = "25"
        self.weatherCondition = "🌤"
    }
}

struct ServiceCardView: View {
    var serviceName: String
    var imageName: String
    
    var body: some View {
        VStack {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 190)
                .cornerRadius(5)
            Text(serviceName)
                .font(.headline)
        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(10)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(ReservationViewModel())
    }
}



