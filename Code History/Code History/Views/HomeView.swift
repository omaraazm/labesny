import SwiftUI

struct HomeView: View {
    @StateObject private var weatherService = WeatherService.shared
    @State private var temperature: Double = -20
    @State private var event: String = ""
    @State private var location: String = ""
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    @State private var selectedOutfit: (shirt: ClothingItem, pants: ClothingItem)?
    
    private func getRandomOutfit() -> (shirt: ClothingItem, pants: ClothingItem)? {
        return allMatchingOutfits.randomElement()
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 16) {
                    HStack {
                        NavigationLink(destination: TripView()) {
                            Image(systemName: "airplane.departure")
                                .font(Font.custom("Helvetica", size: 20).weight(.semibold))
                                .padding()
                                .frame(maxWidth: 100)
                        }
                        Spacer()
                    }
                    .offset(y: -180)
                    .padding(.horizontal)
                    
                    // Main Content
                    VStack(spacing: 32) {
                        ZStack {
                            Image(systemName: "globe")
                                .imageScale(.large)
                        }
                        .padding(40)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("TextTextText. TextText.")
                                .font(Font.custom("Inter", size: 18).weight(.heavy))
                                .foregroundColor(Color(red: 0.12, green: 0.13, blue: 0.14))
                            Text("Please provide the following information. Thank you.")
                                .font(Font.custom("Helvetica", size: 14))
                                .foregroundColor(Color(red: 0.44, green: 0.45, blue: 0.48))
                        }
                        Spacer()
                        
                        VStack(alignment: .leading) {
                            Text("\(Int(temperature))°C")
                                .font(Font.custom("Helvetica", size: 14))
                            Slider(value: $temperature, in: -20...40, step: 1)
                        }
                        .padding(.horizontal)
                        .onAppear {
                            Task {
                                await weatherService.getWeather(latitude: 51.5074, longitude: -0.1278)
                                if let weatherTemp = weatherService.temperature {
                                    temperature = weatherTemp
                                }
                            }
                        }
                        
                        TextField("EVENT", text: $event)
                            .font(Font.custom("Helvetica", size: 14))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                        
                        TextField("LOCATION", text: Binding(
                            get: { location },
                            set: { location = $0.uppercased() }
                        ))
                            .font(Font.custom("Helvetica", size: 14))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                            .onSubmit {
                                Task {
                                    await weatherService
                                        .getWeatherByCity(city: location)
                                    if let weatherTemp = weatherService.temperature {
                                        temperature = weatherTemp
                                    }
                                }
                            }
                        
                        /*
                        DatePicker("START", selection: $startDate, in: Date()..., displayedComponents: .date)
                            .datePickerStyle(.compact)
                        DatePicker("END", selection: $endDate, in: startDate..., displayedComponents: .date)
                            .datePickerStyle(.compact)
                        Spacer()
                         }
                         .datePickerStyle(.graphical)
                         Spacer()
                         */
                        
                        NavigationLink(destination: ContentView(
                            shirt: selectedOutfit?.shirt,
                            pants: selectedOutfit?.pants
                        )) {
                            Text("G E N E R A T E ")
                                .font(Font.custom("Helvetica", size: 12).weight(.semibold))
                                .padding()
                                .frame(maxWidth: .infinity)
                                .cornerRadius(12)
                        }
                        .frame(height: 40)
                        .simultaneousGesture(TapGesture().onEnded {
                            selectedOutfit = getRandomOutfit()
                        })
                    }
                    .padding(24)
                    .frame(height: 322)
                    .offset(y: 50)
                    
                    //Spacer()
                    
                    // Bottom Navigation Bar
                    // Status Bar
                    // Title
                }
            }
        }
    }
}


struct TripView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
