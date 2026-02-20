import Foundation

nonisolated struct SavedRecipe: Identifiable, Codable, Sendable, Hashable {
    let id: String
    let recipe: Recipe
    let savedAt: Date
}
