import Foundation

@Observable
class SavedRecipesStore {
    var savedRecipes: [SavedRecipe] = []

    private let storageKey = "dizzy_dish_saved_recipes"

    init() {
        load()
    }

    func isSaved(_ recipe: Recipe) -> Bool {
        savedRecipes.contains { $0.recipe.id == recipe.id }
    }

    func toggleSave(_ recipe: Recipe) {
        if let index = savedRecipes.firstIndex(where: { $0.recipe.id == recipe.id }) {
            savedRecipes.remove(at: index)
        } else {
            let saved = SavedRecipe(id: recipe.id, recipe: recipe, savedAt: Date())
            savedRecipes.insert(saved, at: 0)
        }
        save()
    }

    func remove(_ saved: SavedRecipe) {
        savedRecipes.removeAll { $0.id == saved.id }
        save()
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(savedRecipes) else { return }
        UserDefaults.standard.set(data, forKey: storageKey)
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let decoded = try? JSONDecoder().decode([SavedRecipe].self, from: data) else { return }
        savedRecipes = decoded
    }
}
