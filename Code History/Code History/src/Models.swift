//
//  Models.swift
//  labesny
//
//  Created by Omar Aboulazm on 04.02.25.
//

import Foundation

struct ClothingItem: Codable, Identifiable, Hashable {
    let id = UUID()
    let type: String
    let color: String
    let dresscode: String
    let fit: String
    //let imageURL: String?
}

struct Outfit: Codable{
    let shirt: ClothingItem
    let pants: ClothingItem
    let score: Double
}


