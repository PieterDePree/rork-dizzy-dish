import Foundation

nonisolated enum Household: String, CaseIterable, Identifiable, Codable, Sendable {
    case solo = "Solo"
    case couple = "Couple"
    case family = "Family"
    case crowd = "Crowd"

    var id: String { rawValue }
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
