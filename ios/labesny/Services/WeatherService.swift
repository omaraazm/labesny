//
//  Weather.swift
//  Code History
//
//  Created by Omar Aboulazm on 17.12.24.
//

import Foundation
import CoreLocation

// @MainActor so every @Published mutation is main-actor isolated. The old
// code set isLoading on a background thread and hopped to the main queue
// mid-flight with DispatchQueue.main.async, which deadlocked the main
// thread inside a @Published setter when a view observing this object was
// being torn down at the same time.
@MainActor
class WeatherService: ObservableObject {
    static let shared = WeatherService()

    @Published var temperature: Double?
    @Published var condition: String?
    @Published var isLoading = false
    @Published var error: String?

    private let apiKey = Secrets.openWeatherMapAPIKey

    init() {}

    func getWeather(latitude: Double, longitude: Double) async {
        isLoading = true
        defer { isLoading = false }

        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&units=metric&appid=\(apiKey)") else {
            error = "Invalid URL"
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let weather = try JSONDecoder().decode(WeatherResponse.self, from: data)

            temperature = weather.main.temp
            condition = weather.weather.first?.description.capitalized ?? "Unknown"
            error = nil
        } catch {
            self.error = error.localizedDescription
            print("Error fetching weather: \(error)")
        }
    }

    func getWeatherByCity(city: String) async {
        isLoading = true
        defer { isLoading = false }

        let encodedCity = city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? city
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(encodedCity)&units=metric&appid=\(apiKey)") else {
            error = "Invalid URL"
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let weather = try JSONDecoder().decode(WeatherResponse.self, from: data)

            temperature = weather.main.temp
            condition = weather.weather.first?.description.capitalized ?? "Unknown"
            error = nil
        } catch {
            self.error = error.localizedDescription
            print("Error fetching weather: \(error)")
        }
    }
}
