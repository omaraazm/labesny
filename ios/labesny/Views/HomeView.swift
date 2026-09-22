import SwiftUI

struct HomeView: View {
    // @ObservedObject, not @StateObject: this view observes a shared
    // singleton it doesn't own. @StateObject made several views each claim
    // ownership of the same instance's lifecycle.
    @ObservedObject private var weatherService = WeatherService.shared
    @State private var temperature: Double = -20
    @State private var event: String = ""
    @State private var location: String = ""
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    @State private var selectedOutfit: (shirt: ClothingItem, pants: ClothingItem)?
    @State private var outfitFetchFailed: Bool = false
    

    
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
                    .offset(y: -130)
                    .padding(.horizontal)
                    
                    // Main Content
                    VStack(spacing: 32) {
                        ZStack {
                            NavigationLink(destination: WardrobeView()) {
                                Image(systemName: "globe")
                                    .imageScale(.large)
                            }
                        }
                        .padding(40)
                        //Spacer(minLength: 400)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("TextTextText. TextText.")
                                .font(Font.custom("Inter", size: 18).weight(.heavy))
                                .foregroundColor(Color(red: 0.12, green: 0.13, blue: 0.14))
                            Text("Please provide the following information. Thank you.")
                                .font(Font.custom("Helvetica", size: 14))
                                .foregroundColor(Color(red: 0.44, green: 0.45, blue: 0.48))
                        }
                        //Spacer()
                        
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
                    }
                    .offset(y: 50)
                    VStack {
                        NavigationLink(destination: ContentView(outfit: selectedOutfit, fetchFailed: outfitFetchFailed)) {
                            Text("G E N E R A T E ")
                                .font(Font.custom("Helvetica", size: 12).weight(.semibold))
                                .foregroundColor(.black)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .cornerRadius(12)
                        }
                        .simultaneousGesture(TapGesture().onEnded {
                            Task {
                                outfitFetchFailed = false
                                do {
                                    let wardrobeService = WardrobeService()
                                    let randomOutfit = try await wardrobeService.fetchRandomOutfit()
                                    selectedOutfit = randomOutfit
                                } catch {
                                    print("Error fetching random outfit: \(error)")
                                    selectedOutfit = nil
                                    outfitFetchFailed = true
                                }
                            }
                        })
                        .padding(24)
                        .frame(height: 10)
                        .offset(y: 90)
                    }
                        //Spacer()
                        
                        // Bottom Navigation Bar
                        // Status Bar
                        // Title
                    }
                }
            }
        }
    }


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
