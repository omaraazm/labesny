import SwiftUI

struct TripView: View {
    @State private var temperature: Double = 20
    @State private var event: String = ""
    @State private var location: String = ""
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 16) {
                    // Profile Section
                    // Main Content
                    VStack(spacing: 32) {
                        ZStack {
                            Image(systemName: "globe")
                                .imageScale(.large)
                        }
                        .padding(40)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("TextTextTextText. TripTrip.")
                                .font(Font.custom("Inter", size: 18).weight(.heavy))
                                .foregroundColor(Color(red: 0.12, green: 0.13, blue: 0.14))
                            Text("Please provide the following information. Thank you.")
                                .font(Font.custom("Helvetica", size: 14))
                                .foregroundColor(Color(red: 0.44, green: 0.45, blue: 0.48))
                        }
                        Spacer()
                        
                            TextField("EVENTS", text: $event)
                                .font(Font.custom("Helvetica", size: 14))
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.horizontal)
                            
                            
                            TextField("LOCATION", text: $location)
                                .font(Font.custom("Helvetica", size: 14))
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.horizontal)
                            
                            
                            DatePicker("START", selection: $startDate, in: Date()..., displayedComponents: .date)
                                .datePickerStyle(.compact)
                                .font(.custom("Helvetica", size: 14))
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.horizontal)
                                .tint(.black)
                            DatePicker("END", selection: $endDate, in: startDate..., displayedComponents: .date)
                                .datePickerStyle(.compact)
                                .font(.custom("Helvetica", size: 14))
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.horizontal)
                                .tint(.black)
                            Spacer()
                            
                            NavigationLink(destination: TripContentView()) {
                                Text("G E N E R A T E ")
                                    .font(Font.custom("Helvetica", size: 12).weight(.semibold))
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .cornerRadius(12)
                            }
                            .frame(height: 40)
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


#Preview {
    TripView()
}
