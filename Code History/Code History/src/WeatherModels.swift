//
//  WeatherModels.swift
//  labesny
//
//  Created by Omar Aboulazm on 05.02.25.
//

import Foundation

// Data structures for JSON decoding
struct WeatherResponse: Codable {
    let main: MainWeather
    let weather: [WeatherCondition]
}

struct MainWeather: Codable {
    let temp: Double
}

struct WeatherCondition: Codable {
    let description: String
}
