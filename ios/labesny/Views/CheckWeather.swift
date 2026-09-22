//
//  CheckWeather.swift
//  Code History
//
//  Created by Omar Aboulazm on 17.12.24.
//

import SwiftUI

// SwiftUI View
struct CheckWeather: View {
    @StateObject private var weatherService = WeatherService.shared
    
    var body: some View {
        VStack {
            if let temperature = weatherService.temperature {
                Text("\(temperature, specifier: "%.1f")°C")
                    .font(Font.custom("Helvetica", size: 30))

            } else {
                Text("Loading temperature...".uppercased())
                    .font(Font.custom("Helvetica", size: 14))
            }
            
            if let condition = weatherService.condition {
                Text(condition.uppercased())
                    .font(Font.custom("Helvetica", size: 25))

            } else {
                Text("Loading conditions...".uppercased())
                    .font(Font.custom("Helvetica", size: 14))
            }
        }
        .padding()
        .onAppear {
            Task {
                await weatherService.getWeather(latitude: 51.5074, longitude: -0.1278)
            }
        }
    }
}

#Preview {
    CheckWeather()
       // .environment(\.isPreview, true)
}
