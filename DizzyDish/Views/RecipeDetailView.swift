import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    @Environment(SavedRecipesStore.self) private var savedStore
    @State private var checkedIngredients: Set<String> = []
    @State private var completedSteps: Set<Int> = []
    @State private var isCookMode: Bool = false
    @State private var showScaler: Bool = false
    @State private var scaleFactor: Double?
    @State private var isScaled: Bool = false

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                heroImage

                VStack(alignment: .leading, spacing: DS.Spacing.xl + DS.Spacing.micro) {
                    headerSection
                    dietaryTags
                    ingredientsSection
                    stepsSection
                }
                .padding(DS.Spacing.large + DS.Spacing.micro)
            }
        }
        .scrollIndicators(.hidden)
        .background(DS.Colors.background)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                HStack(spacing: DS.Spacing.medium) {
                    Button {
                        if scaleFactor != nil {
                            withAnimation(.snappy) { isScaled.toggle() }
                        } else {
                            showScaler = true
                        }
                    } label: {
                        Image(systemName: isScaled ? "scalemass.fill" : "scalemass")
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(isScaled ? DS.Colors.warm : DS.Colors.textSoft)
                    }
                    .sensoryFeedback(.selection, trigger: isScaled)
                    .contextMenu {
                        if scaleFactor != nil {
                            Button {
                                showScaler = true
                            } label: {
                                Label("Reconfigure", systemImage: "slider.horizontal.3")
                            }
                            Button(role: .destructive) {
                                withAnimation(.snappy) {
                                    scaleFactor = nil
                                    isScaled = false
                                }
                            } label: {
                                Label("Clear Scaling", systemImage: "xmark.circle")
                            }
                        }
                    }

                    Button {
                        withAnimation(.snappy) { isCookMode.toggle() }
                    } label: {
                        Image(systemName: isCookMode ? "book.closed.fill" : "book.closed")
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(DS.Colors.warm)
                    }

                    Button {
                        savedStore.toggleSave(recipe)
                    } label: {
                        Image(systemName: savedStore.isSaved(recipe) ? "heart.fill" : "heart")
                            .foregroundStyle(savedStore.isSaved(recipe) ? DS.Colors.warm : DS.Colors.textPrimary)
                    }
                }
            }
        }
        .sensoryFeedback(.selection, trigger: isCookMode)
        .sheet(isPresented: $showScaler) {
            RecipeScalerView(recipe: recipe) { factor in
                scaleFactor = factor
                withAnimation(.snappy) { isScaled = true }
            }
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
            .presentationContentInteraction(.scrolls)
        }
    }

    private var heroImage: some View {
        DS.Colors.cream
            .frame(height: 240)
            .overlay {
                AsyncImage(url: URL(string: recipe.imageURL)) { phase in
                    if let image = phase.image {
                        image.resizable().aspectRatio(contentMode: .fill)
                    } else if phase.error != nil {
                        Image(systemName: "photo")
                            .font(.largeTitle)
                            .foregroundStyle(DS.Colors.textLight)
                    } else {
                        ProgressView()
                            .tint(DS.Colors.warm)
                    }
                }
                .allowsHitTesting(false)
            }
            .clipped()
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.small) {
            Text(recipe.title)
                .font(isCookMode ? DS.Typography.displayLarge : DS.Typography.displayMedium)
                .foregroundStyle(DS.Colors.textPrimary)

            HStack(spacing: DS.Spacing.large) {
                Label(recipe.timeLabel, systemImage: "clock.fill")
                if isScaled, let factor = scaleFactor {
                    let scaledServings = max(1, Int(round(Double(recipe.servings) * factor)))
                    Label("\(scaledServings) servings", systemImage: "person.2.fill")
                } else {
                    Label("\(recipe.servings) servings", systemImage: "person.2.fill")
                }
                Label(recipe.difficulty, systemImage: recipe.difficultyIcon)
            }
            .font(isCookMode ? DS.Typography.bodyMedium : DS.Typography.bodySmall)
            .foregroundStyle(DS.Colors.textSoft)
        }
    }

    @ViewBuilder
    private var dietaryTags: some View {
        if !recipe.dietaryTags.isEmpty {
            HStack(spacing: DS.Spacing.small) {
                ForEach(recipe.dietaryTags, id: \.self) { tag in
                    Text(tag)
                        .font(DS.Typography.labelSmall)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(DS.Colors.green.opacity(0.12))
                        .foregroundStyle(DS.Colors.green)
                        .clipShape(Capsule())
                }
            }
        }
    }

    private var ingredientsSection: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.medium) {
            HStack {
                Text("Ingredients")
                    .font(isCookMode ? DS.Typography.displaySmall : DS.Typography.titleMedium)
                    .foregroundStyle(DS.Colors.textPrimary)

                Spacer()

                if isScaled, let factor = scaleFactor {
                    let percent = Int(round(factor * 100))
                    Text("\(percent)%")
                        .font(DS.Typography.labelMedium)
                        .foregroundStyle(DS.Colors.warm)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(DS.Colors.warm.opacity(0.1))
                        .clipShape(Capsule())
                }
            }

            VStack(spacing: 2) {
                ForEach(recipe.ingredients) { ingredient in
                    let isChecked = checkedIngredients.contains(ingredient.id)
                    Button {
                        withAnimation(.snappy) {
                            if isChecked {
                                checkedIngredients.remove(ingredient.id)
                            } else {
                                checkedIngredients.insert(ingredient.id)
                            }
                        }
                    } label: {
                        HStack(spacing: DS.Spacing.medium) {
                            Image(systemName: isChecked ? "checkmark.circle.fill" : "circle")
                                .font(.body)
                                .foregroundStyle(isChecked ? DS.Colors.green : DS.Colors.textLight)

                            Text(displayText(for: ingredient))
                                .font(isCookMode ? DS.Typography.bodyLarge : DS.Typography.bodyMedium)
                                .foregroundStyle(isChecked ? DS.Colors.textSoft : DS.Colors.textPrimary)
                                .strikethrough(isChecked)
                                .contentTransition(.numericText())

                            Spacer()
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, DS.Spacing.medium)
                        .contentShape(Rectangle())
                    }
                    .sensoryFeedback(.selection, trigger: isChecked)
                }
            }
            .background(DS.Colors.card)
            .clipShape(.rect(cornerRadius: DS.Radius.medium))
            .overlay(
                RoundedRectangle(cornerRadius: DS.Radius.medium)
                    .stroke(DS.Colors.border, lineWidth: 1)
            )
        }
    }

    private var stepsSection: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.medium) {
            Text("Steps")
                .font(isCookMode ? DS.Typography.displaySmall : DS.Typography.titleMedium)
                .foregroundStyle(DS.Colors.textPrimary)

            VStack(spacing: DS.Spacing.medium) {
                ForEach(recipe.steps) { step in
                    Button {
                        withAnimation(.snappy) {
                            if completedSteps.contains(step.id) {
                                completedSteps.remove(step.id)
                            } else {
                                completedSteps.insert(step.id)
                            }
                        }
                    } label: {
                        HStack(alignment: .top, spacing: DS.Spacing.medium) {
                            ZStack {
                                Circle()
                                    .fill(
                                        completedSteps.contains(step.id)
                                            ? DS.Colors.green
                                            : DS.Colors.warmPale
                                    )
                                    .frame(width: 32, height: 32)

                                if completedSteps.contains(step.id) {
                                    Image(systemName: "checkmark")
                                        .font(.caption.weight(.bold))
                                        .foregroundStyle(.white)
                                } else {
                                    Text("\(step.id)")
                                        .font(DS.Typography.labelMedium)
                                        .foregroundStyle(DS.Colors.textSoft)
                                }
                            }

                            VStack(alignment: .leading, spacing: DS.Spacing.micro) {
                                Text(step.instruction)
                                    .font(isCookMode ? DS.Typography.bodyLarge : DS.Typography.bodyMedium)
                                    .foregroundStyle(
                                        completedSteps.contains(step.id) ? DS.Colors.textSoft : DS.Colors.textPrimary
                                    )
                                    .multilineTextAlignment(.leading)
                                    .fixedSize(horizontal: false, vertical: true)

                                if let duration = step.duration {
                                    Label("\(duration) min", systemImage: "timer")
                                        .font(DS.Typography.bodySmall)
                                        .foregroundStyle(DS.Colors.warm)
                                }
                            }

                            Spacer()
                        }
                        .padding(DS.Spacing.medium)
                        .background(DS.Colors.card)
                        .clipShape(.rect(cornerRadius: DS.Radius.medium))
                        .overlay(
                            RoundedRectangle(cornerRadius: DS.Radius.medium)
                                .stroke(DS.Colors.border, lineWidth: 1)
                        )
                        .contentShape(Rectangle())
                    }
                    .sensoryFeedback(.impact(weight: .light), trigger: completedSteps.contains(step.id))
                }
            }
        }
    }

    private func displayText(for ingredient: Ingredient) -> String {
        if isScaled, let factor = scaleFactor {
            return IngredientScaler.scaledDisplayText(for: ingredient, factor: factor)
        }
        return ingredient.displayText
    }
}
