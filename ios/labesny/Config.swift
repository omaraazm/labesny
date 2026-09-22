//
//  Config.swift
//  labesny
//

import Foundation

enum Config {
    /// Backend base URL. Points at this Mac's LAN IP so the app works from
    /// the Simulator and from a physical device on the same WiFi.
    static let backendBaseURL = "http://192.168.1.9:8000"
}
