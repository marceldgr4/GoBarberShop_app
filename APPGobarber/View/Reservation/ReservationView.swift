import SwiftUI

struct ReservationView: View {
    @EnvironmentObject var viewModel: ReservationViewModel

    @State private var selectedBarberShop: BarberShop?
    @State private var selectedBarber: Barber?
    @State private var selectedService: ServiceBarber?
    @State private var selectedDate = Date()
    @State private var selectedTimeSlot: String?

    var body: some View {
        NavigationView {
            Form {
// Barbershop selection
                Section(header: Text("Select Barbershop")) {
                    Picker("Barbershop", selection: $selectedBarberShop) {
                        Text("Select a barbershop").tag(nil as BarberShop?)
                        ForEach(viewModel.barbershops) { barbershop in
                            Text(barbershop.name).tag(barbershop as BarberShop?)
                        }
                    }
                    .onChange(of: selectedBarberShop) { newValue in
                        if let barbershop = newValue {
                            Task {
                                await viewModel.fetchBarbers(barbershopId: barbershop.id!)
                            }
                        } else {
                            viewModel.barbers = []
                        }
                        selectedBarber = nil
                        selectedTimeSlot = nil
                    }
                }
                
                // Barber selection
                if selectedBarberShop != nil {
                    Section(header: Text("Select Barber")) {
                        Picker("Barber", selection: $selectedBarber) {
                            Text("Select a barber").tag(nil as Barber?)
                            ForEach(viewModel.barbers) { barber in
                                Text(barber.name).tag(barber as Barber?)
                            }
                        }
                        .onChange(of: selectedBarber) { newValue in
                            if let barber = newValue {
                                Task {
                                    await viewModel.fetchAvailableTimeSlots(for: barber.id!, on: selectedDate)
                                }
                            } else {
                                viewModel.availableTimeSlots = []
                            }
                            selectedTimeSlot = nil
                        }
                    }
                }
                
                // Service selection
                Section(header: Text("Select Service")) {
                    Picker("Service", selection: $selectedService) {
                        Text("Select a service").tag(nil as ServiceBarber?)
                        ForEach(viewModel.services) { service in
                            Text(service.name).tag(service as ServiceBarber?)
                        }
                    }
                    .onAppear {
                        Task {
                            await viewModel.fetchServices()
                        }
                    }
                }
                
                // Date selection
                Section(header: Text("Select Date")) {
                    DatePicker("Date", selection: $selectedDate, displayedComponents: .date)
                }
                
                // Time slot selection
                if let barber = selectedBarber {
                    Section(header: Text("Select Time Slot")) {
                        Picker("Time Slot", selection: $selectedTimeSlot) {
                            Text("Select a time slot").tag(nil as String?)
                            ForEach(viewModel.availableTimeSlots, id: \.self) { timeSlot in
                                Text(timeSlot).tag(timeSlot as String?)
                            }
                        }
                        .onAppear {
                            Task {
                                await viewModel.fetchAvailableTimeSlots(for: barber.id!, on: selectedDate)
                            }
                        }
                    }
                }
                
                // Reserve button
                Button(action: {
                    guard let barbershop = selectedBarberShop,
                          let barber = selectedBarber,
                          let service = selectedService,
                          let timeSlot = selectedTimeSlot else { return }
                    Task {
                        await viewModel.createReservation(barberShop: barbershop, barber: barber, service: service, date: selectedDate, timeSlot: timeSlot)
                    }
                }) {
                    Text("Reserve")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .disabled(selectedBarberShop == nil || selectedBarber == nil || selectedService == nil || selectedTimeSlot == nil)
            }
            .navigationTitle("New Reservation")
        }
        .onAppear {
            Task {
                await viewModel.loadData()
            }
        }
    }
}
   

struct ReservationView_Previews: PreviewProvider {
    static var previews: some View {
        ReservationView().environmentObject(ReservationViewModel())            
    }
}
