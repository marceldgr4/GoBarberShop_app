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
                        ForEach(viewModel.barbershops, id: \.id) { barbershop in
                            Text(barbershop.name).tag(barbershop as BarberShop?)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                .onChange(of: selectedBarberShop) { newValue in
                    Task {
                        if let barbershop = newValue {
                            await viewModel.fetchBarbers(barbershopId: barbershop.id!)
                        }
                    }
                }

                // Barber selection
                if selectedBarberShop != nil {
                    Section(header: Text("Select Barber")) {
                        Picker("Barber", selection: $selectedBarber) {
                            ForEach(viewModel.barbers.filter { $0.barbershopId == selectedBarberShop?.id }, id: \.id) { barber in
                                Text(barber.name).tag(barber as Barber?)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                }

                // Service selection
                Section(header: Text("Select Service")) {
                    Picker("Service", selection: $selectedService) {
                        ForEach(viewModel.services, id: \.id) { service in
                            Text(service.name).tag(service as ServiceBarber?)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }

                // Date selection
                Section(header: Text("Select Date")) {
                    DatePicker("Date", selection: $selectedDate, displayedComponents: .date)
                }

                // Time slot selection
                if selectedBarber != nil {
                    Section(header: Text("Select Time Slot")) {
                        Picker("Time Slot", selection: $selectedTimeSlot) {
                            ForEach(viewModel.availableTimeSlots, id: \.self) { timeSlot in
                                Text(timeSlot).tag(timeSlot as String?)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                }

                // Reserve button
                Section {
                    Button(action: {
                        guard let barbershop = selectedBarberShop,
                              let barber = selectedBarber,
                              let service = selectedService,
                              let timeSlot = selectedTimeSlot else { return }
                        Task {
                            await viewModel.createReservation(BarberShop: barbershop, Barber: barber, ServiceBarber: service, date: selectedDate, timeSlot: timeSlot)
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
            }
            .navigationTitle("New Reservation")
        }
        .onAppear {
            Task {
                await viewModel.loadData()
            }
        }
        .onChange(of: selectedBarber) { _ in
            updateAvailableTimeSlots()
        }
        .onChange(of: selectedDate) { _ in
            updateAvailableTimeSlots()
        }
        .onChange(of: selectedService) { _ in
            updateAvailableTimeSlots()
        }
    }

    private func updateAvailableTimeSlots() {
        if let barber = selectedBarber {
            Task {
                await viewModel.fetchAvailableTimeSlots(for: barber.id!, on: selectedDate)
            }
        }
    }
}

struct ReservationView_Previews: PreviewProvider {
    static var previews: some View {
         ReservationView()
            
    }
}
