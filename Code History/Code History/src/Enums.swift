//
//  Enums.swift
//  labesny
//
//  Created by Omar Aboulazm on 05.02.25.
//

import Foundation

enum DressCode: String, CaseIterable, Hashable {
    case formal = "formal"
    case casual = "casual"
}

enum ClothingType: String, CaseIterable, Hashable {
    case shirt = "shirt"
    case pants = "pants"
    // case hoodie = "hoodie"
}

enum ClothingFit: String, CaseIterable, Hashable {
    case slim = "slim"
    case regular = "regular"
    case oversized = "oversized"
}

enum ImageServiceError: Error {
    case invalidImageData
    case uploadFailed
    case invalidResponse
}
