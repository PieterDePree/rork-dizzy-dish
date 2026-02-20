import Foundation

nonisolated enum Household: String, CaseIterable, Identifiable, Codable, Sendable {
    case solo = "Solo"
    case couple = "Couple"
    case family = "Family"
    case crowd = "Crowd"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .solo: return "person.fill"
        case .couple: return "person.2.fill"
        case .family: return "figure.2.and.child.holdinghands"
        case .crowd: return "person.3.fill"
        }
    }

    var subtitle: String {
        switch self {
        case .solo: return "Cooking for one"
        case .couple: return "Meals for two"
        case .family: return "3–5 servings"
        case .crowd: return "6+ servings"
        }
    }
}

nonisolated struct UserPreferences: Codable, Sendable, Hashable {
    var household: Household
    var dietaryNeeds: [String]
    var favoriteCuisines: [String]
    var avoidIngredients: [String]

    static let empty = UserPreferences(
        household: .family,
        dietaryNeeds: [],
        favoriteCuisines: [],
        avoidIngredients: []
    )
}

nonisolated enum PreferenceSuggestions: Sendable {
    static let dietaryNeeds: [(String, String)] = [
        ("Vegetarian", "leaf.fill"),
        ("Vegan", "carrot.fill"),
        ("Gluten-Free", "wheat.bundle.fill"),
        ("Dairy-Free", "drop.fill"),
        ("Nut-Free", "allergens.fill"),
        ("Keto", "flame.fill"),
        ("Paleo", "fossil.shell.fill"),
        ("Low-Carb", "chart.bar.fill"),
        ("Halal", "moon.stars.fill"),
        ("Kosher", "star.fill"),
        ("Pescatarian", "fish.fill"),
        ("Low-Sodium", "drop.triangle.fill")
    ]

    static let cuisines: [(String, String)] = [
        ("Italian", "fork.knife"),
        ("Mexican", "sun.max.fill"),
        ("Japanese", "wand.and.stars"),
        ("Chinese", "flame.fill"),
        ("Indian", "sparkles"),
        ("Thai", "leaf.fill"),
        ("Mediterranean", "drop.fill"),
        ("Korean", "frying.pan.fill"),
        ("French", "wineglass.fill"),
        ("American", "star.fill"),
        ("Vietnamese", "cup.and.saucer.fill"),
        ("Middle Eastern", "moon.fill"),
        ("Greek", "sun.haze.fill"),
        ("Caribbean", "water.waves"),
        ("Ethiopian", "globe.americas.fill"),
        ("Southern", "house.fill")
    ]

    static let avoidIngredients: [(String, String)] = [
        ("Peanuts", "allergens.fill"),
        ("Tree Nuts", "leaf.fill"),
        ("Shellfish", "fish.fill"),
        ("Eggs", "oval.fill"),
        ("Soy", "drop.fill"),
        ("Wheat", "wheat.bundle.fill"),
        ("Sesame", "circle.grid.3x3.fill"),
        ("Milk", "cup.and.saucer.fill"),
        ("Mushrooms", "cloud.fill"),
        ("Cilantro", "leaf.fill"),
        ("Onion", "circle.fill"),
        ("Garlic", "circle.fill")
    ]
}
