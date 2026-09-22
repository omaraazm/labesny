//
//  WardrobeService.swift
//  labesny
//
//  Created by Omar Aboulazm on 04.02.25.
//

import Foundation

class WardrobeService: ObservableObject {
    private let baseURL = Config.backendBaseURL
    @Published var items: [ClothingItem] = []
    @Published var outfits: [Outfit] = []

    func addItem(_ item: ClothingItem) async throws {
        guard let url = URL(string: "\(baseURL)/items/") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        var requestBody: [String: Any] = [
            "type": item.type,
            "color": item.color,
            "dresscode": item.dresscode,
            "fit": item.fit
        ]
        if let imageURL = item.imageURL {
            requestBody["image_url"] = imageURL
        }
        
        // Convert dictionary to JSON data
        let jsonData = try JSONSerialization.data(withJSONObject: requestBody)
        request.httpBody = jsonData
        
        // For debugging
        if let jsonString = String(data: jsonData, encoding: .utf8) {
            print("Request body: \(jsonString)")
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // For debugging
        print("URL being called:", url.absoluteString)
        if let responseString = String(data: data, encoding: .utf8) {
            print("Response: \(responseString)")
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        if httpResponse.statusCode == 422 {
            if let responseString = String(data: data, encoding: .utf8) {
                print("422 Error Response Details:", responseString)
            }
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        let newItem = try JSONDecoder().decode(ClothingItem.self, from: data)
        
        DispatchQueue.main.async {
            self.items.append(newItem)
        }
    }
    
    func fetchItems() async throws {
        guard let url = URL(string: "\(baseURL)/items/") else { return }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let items = try JSONDecoder().decode([ClothingItem].self, from: data)
        
        DispatchQueue.main.async {
            self.items = items
        }
    }
    
    func fetchOutfits() async throws {
        guard let url = URL(string: "\(baseURL)/outfits/") else { return }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let outfits = try JSONDecoder().decode([Outfit].self, from: data)
        
        DispatchQueue.main.async {
            self.outfits = outfits
        }
    }
    
    func fetchRandomOutfit() async throws -> (shirt: ClothingItem, pants: ClothingItem) {
        guard let url = URL(string: "\(baseURL)/outfits/random/") else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let outfit = try JSONDecoder().decode(Outfit.self, from: data)
        
        return (shirt: outfit.shirt, pants: outfit.pants)
    }
    
    func removeItem(id: String) async throws {
        guard let url = URL(string: "\(baseURL)/items/\(id)") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        let (_, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        DispatchQueue.main.async {
            self.items.removeAll { $0.id == id }
        }
    }
}
