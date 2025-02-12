//
//  Weather.swift
//  Code History
//
//  Created by Omar Aboulazm on 17.12.24.
//

import Foundation
import WeatherKit
import CoreLocation


class WeatherService: ObservableObject {
    static let shared = WeatherService()
    
    @Published var temperature: Double?
    @Published var condition: String?
    @Published var isLoading = false
    @Published var error: String?
    
    private let apiKey = "54465babc5c87eefaefbd2066dae3f34"
    
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
            
            DispatchQueue.main.async {
                self.temperature = weather.main.temp
                self.condition = weather.weather.first?.description.capitalized ?? "Unknown"
                self.error = nil
            }
        } catch {
            DispatchQueue.main.async {
                self.error = error.localizedDescription
                print("Error fetching weather: \(error)")
            }
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
            
            DispatchQueue.main.async {
                self.temperature = weather.main.temp
                self.condition = weather.weather.first?.description.capitalized ?? "Unknown"
                self.error = nil
            }
        } catch {
            DispatchQueue.main.async {
                self.error = error.localizedDescription
                print("Error fetching weather: \(error)")
            }
        }
    }
}

