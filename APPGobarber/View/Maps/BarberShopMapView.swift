/*import SwiftUI
import MapKit
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct BarberShopMapView: View {
    @EnvironmentObject var viewModel: BarberShopViewModel
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    var body: some View {
        NavigationView {
            Map(coordinateRegion: $region, annotationItems: viewModel.barbershops) { barbershop in
                MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: barbershop.coordinates.latitude, longitude: barbershop.coordinates.longitude)) {
                    NavigationLink(destination: BarbershopDetailView(barbershop: barbershop)) {
                        VStack {
                            Text(barbershop.name)
                                .font(.caption)
                                .padding(5)
                                .background(Color.white)
                                .cornerRadius(10)
                            Image(systemName: "mappin.circle.fill")
                                .foregroundColor(.red)
                                .font(.title)
                        }
                    }
                }
            }
            .navigationTitle("Mapa de Barberías")
            .onAppear {
                Task {
                    await viewModel.fetchBarbershops()
                }
            }
        }
    }
}

struct BarberShopMapView_Previews: PreviewProvider {
    static var previews: some View {
        BarberShopMapView().environmentObject(BarberShopViewModel())
    }
}
*/
