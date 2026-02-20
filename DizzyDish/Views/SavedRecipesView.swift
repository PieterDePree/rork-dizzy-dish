import SwiftUI

struct SavedRecipesView: View {
    @Environment(SavedRecipesStore.self) private var savedStore

    var body: some View {
        NavigationStack {
            Group {
                if savedStore.savedRecipes.isEmpty {
                    ContentUnavailableView(
                        "No Saved Recipes",
                        systemImage: "heart.slash",
                        description: Text("Recipes you save will appear here.\nSpin to discover something delicious!")
                    )
                } else {
                    List {
                        ForEach(savedStore.savedRecipes) { saved in
                            NavigationLink(value: saved) {
                                SavedRecipeRow(saved: saved)
                            }
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                savedStore.remove(savedStore.savedRecipes[index])
                            }
                        }
                        .listRowBackground(DS.Colors.card)
                    }
                    .listStyle(.plain)
                    .navigationDestination(for: SavedRecipe.self) { saved in
                        RecipeDetailView(recipe: saved.recipe)
                    }
                }
            }
            .background(DS.Colors.background)
            .scrollContentBackground(.hidden)
            .navigationTitle("Saved")
        }
    }
}

struct SavedRecipeRow: View {
    let saved: SavedRecipe

    var body: some View {
        HStack(spacing: DS.Spacing.medium) {
            DS.Colors.cream
                .frame(width: 72, height: 72)
                .overlay {
                    AsyncImage(url: URL(string: saved.recipe.imageURL)) { phase in
                        if let image = phase.image {
                            image.resizable().aspectRatio(contentMode: .fill)
                        }
                    }
                    .allowsHitTesting(false)
                }
                .clipShape(.rect(cornerRadius: DS.Radius.small))

            VStack(alignment: .leading, spacing: DS.Spacing.micro) {
                Text(saved.recipe.title)
                    .font(DS.Typography.labelLarge)
                    .foregroundStyle(DS.Colors.textPrimary)
                    .lineLimit(2)

                HStack(spacing: DS.Spacing.small) {
                    Label(saved.recipe.timeLabel, systemImage: "clock")
                    Label(saved.recipe.cuisineType, systemImage: "fork.knife")
                }
                .font(DS.Typography.bodySmall)
                .foregroundStyle(DS.Colors.textSoft)
            }

            Spacer()
        }
        .padding(.vertical, DS.Spacing.micro)
    }
}
