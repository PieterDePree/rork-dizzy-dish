import Foundation

nonisolated struct Ingredient: Identifiable, Codable, Sendable, Hashable {
    let id: String
    let name: String
    let amount: String
    let unit: String

    var displayText: String {
        if unit.isEmpty {
            return "\(amount) \(name)"
        }
        return "\(amount) \(unit) \(name)"
    }
}

nonisolated struct RecipeStep: Identifiable, Codable, Sendable, Hashable {
    let id: Int
    let instruction: String
    let duration: Int?
}

nonisolated struct Recipe: Identifiable, Codable, Sendable, Hashable {
    let id: String
    let title: String
    let imageURL: String
    let cookTime: Int
    let prepTime: Int
    let servings: Int
    let difficulty: String
    let cuisineType: String
    let vibes: [String]
    let reason: String
    let ingredients: [Ingredient]
    let steps: [RecipeStep]
    let dietaryTags: [String]

    var totalTime: Int { prepTime + cookTime }

    var timeLabel: String {
        if totalTime < 60 {
            return "\(totalTime) min"
        }
        let hours = totalTime / 60
        let mins = totalTime % 60
        return mins > 0 ? "\(hours)h \(mins)m" : "\(hours)h"
    }

    var difficultyIcon: String {
        switch difficulty.lowercased() {
        case "easy": return "leaf.fill"
        case "medium": return "flame.fill"
        case "hard": return "star.fill"
        default: return "leaf.fill"
        }
    }
}
