//
//  Models.swift
//  labesny
//
//  Created by Omar Aboulazm on 04.02.25.
//

import Foundation

struct ClothingItem: Codable, Identifiable, Hashable {
    let id: String
    let type: String
    let color: String
    let dresscode: String
    let fit: String
    let imageURL: String?

    enum CodingKeys: String, CodingKey {
        case id, type, color, dresscode, fit
        case imageURL = "image_url"
    }

    init(id: String = UUID().uuidString, type: String, color: String, dresscode: String, fit: String, imageURL: String? = nil) {
        self.id = id
        self.type = type
        self.color = color
        self.dresscode = dresscode
        self.fit = fit
        self.imageURL = imageURL
    }
}

struct Outfit: Codable{
    let shirt: ClothingItem
    let pants: ClothingItem
    let score: Double
}

