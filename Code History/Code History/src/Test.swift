import Foundation

// Define dress codes
enum DressCode {
    case formal
    case casual
}

enum ClothingType {
    case shirt
    case pants
}

enum ClothingFit {
    case slim
    case regular
    case oversized
}

struct ClothingItem: Hashable {
    let type: ClothingType
    let color: String
    let code: DressCode
    //let fit: ClothingFit
    
    // Helper method to sort items
    var isShirt: Bool {
        return type == .shirt
    }
    
    var isPants: Bool {
        return type == .pants
    }
    var isFormal: Bool {
        return code == .formal
    }
    var isCasual: Bool {
        return code == .casual
    }   
    /*
    var isShoes: Bool {
        return type == .shoes
    }
    */
}

// Add color matching rules
struct ColorMatchingRules {
    // Dictionary where key is a color and value is set of compatible colors
    static let compatibleColors: [String: Set<String>] = [
        "White": Set(["Blue", "Green", "Grey", "Red"]), // White goes with everything
        "Grey": Set(["Blue", "Red"]),                  // Grey goes with blue and red
        "Blue": Set(["White", "Grey", "Red"]),         // Blue goes with white, grey and red
        "Green": Set(["White", "Grey", "Red"]),        // Green goes with white, grey and red
        "Red": Set(["White", "Grey", "Blue", "Green"]) // Red goes with all colors
    ]
    
    static func colorsMatch(_ color1: String, _ color2: String) -> Bool {
        // Check if either color is compatible with the other
        return compatibleColors[color1]?.contains(color2) == true ||
               compatibleColors[color2]?.contains(color1) == true
    }
}

// Add matching logic to ClothingItem
extension ClothingItem {
    func matches(with other: ClothingItem) -> Bool {
        // Items must have the same dress code and matching colors
        guard self.code == other.code else {
            return false
        }
        return ColorMatchingRules.colorsMatch(self.color, other.color)
    }
}

// Update the test items with dress codes
let items: Set<ClothingItem> = [
    ClothingItem(type: .shirt, color: "White", code: .formal),
    ClothingItem(type: .shirt, color: "Grey", code: .casual),
    ClothingItem(type: .pants, color: "Blue", code: .casual),
    ClothingItem(type: .pants, color: "Green", code: .formal)
]

// Create filtered sets using filter
let shirts = Set(items.filter { $0.isShirt })
let pants = Set(items.filter { $0.isPants })

// Find matching outfits
func findMatchingOutfits(from items: Set<ClothingItem>) -> [(shirt: ClothingItem, pants: ClothingItem)] {
    var matches: [(shirt: ClothingItem, pants: ClothingItem)] = []
    
    // Get all shirts and pants
    let shirts = items.filter { $0.isShirt }
    let pants = items.filter { $0.isPants }
    
    // Match each shirt with compatible pants
    for shirt in shirts {
        for pant in pants {
            if shirt.matches(with: pant) {
                matches.append((shirt: shirt, pants: pant))
            }
        }
    }
    
    return matches
}
/*
// Test the matches
let matchingOutfits = findMatchingOutfits(from: items)
print("\nMatching Outfits:")
matchingOutfits.forEach { outfit in
    print("\(outfit.shirt.color) \(outfit.shirt.code) shirt with \(outfit.pants.color) \(outfit.pants.code) pants")
}
*/
