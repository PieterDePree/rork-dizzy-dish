import SwiftUI

struct RecipeScalerView: View {
    let recipe: Recipe
    var onApply: (Double) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var selectedIngredientID: String?
    @State private var availableAmount: String = ""
    @FocusState private var isInputFocused: Bool

    private var scaleFactor: Double? {
        guard let selected = recipe.ingredients.first(where: { $0.id == selectedIngredientID }),
              let original = IngredientScaler.parseNumber(from: selected.amount),
              original > 0,
              let available = Double(availableAmount),
              available > 0 else {
            return nil
        }
        return available / original
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: DS.Spacing.xl) {
                    constraintSection

                    if let factor = scaleFactor {
                        let percent = Int(round(factor * 100))
                        let scaledServings = max(1, Int(round(Double(recipe.servings) * factor)))

                        VStack(alignment: .leading, spacing: DS.Spacing.small) {
                            HStack(spacing: DS.Spacing.small) {
                                Image(systemName: "arrow.up.arrow.down")
                                    .foregroundStyle(DS.Colors.warm)
                                Text("Scales to \(percent)%")
                                    .font(DS.Typography.displaySmall)
                                    .foregroundStyle(DS.Colors.textPrimary)
                            }
                            Text("\(scaledServings) serving\(scaledServings == 1 ? "" : "s")")
                                .font(DS.Typography.bodySmall)
                                .foregroundStyle(DS.Colors.textSoft)
                        }
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    } else if selectedIngredientID != nil {
                        HStack(spacing: DS.Spacing.small) {
                            Image(systemName: "hand.point.up.left.fill")
                                .foregroundStyle(DS.Colors.warm.opacity(0.5))
                            Text("Enter how much you have")
                                .font(DS.Typography.bodyMedium)
                                .foregroundStyle(DS.Colors.textSoft)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, DS.Spacing.xl)
                    }
                }
                .padding(DS.Spacing.large + DS.Spacing.micro)
                .animation(.snappy, value: scaleFactor != nil)
            }
            .scrollIndicators(.hidden)
            .background(DS.Colors.background)
            .navigationTitle("Scale Recipe")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                        .foregroundStyle(DS.Colors.textSoft)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Apply") {
                        if let factor = scaleFactor {
                            onApply(factor)
                            dismiss()
                        }
                    }
                    .fontWeight(.semibold)
                    .foregroundStyle(scaleFactor != nil ? DS.Colors.warm : DS.Colors.textLight)
                    .disabled(scaleFactor == nil)
                }
            }
        }
    }

    private var constraintSection: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.medium) {
            VStack(alignment: .leading, spacing: DS.Spacing.micro) {
                Text("What's your limit?")
                    .font(DS.Typography.displaySmall)
                    .foregroundStyle(DS.Colors.textPrimary)
                Text("Tap the ingredient you have less of")
                    .font(DS.Typography.bodySmall)
                    .foregroundStyle(DS.Colors.textSoft)
            }

            VStack(spacing: 2) {
                ForEach(recipe.ingredients) { ingredient in
                    let isSelected = selectedIngredientID == ingredient.id
                    Button {
                        withAnimation(.snappy) {
                            if isSelected {
                                selectedIngredientID = nil
                                availableAmount = ""
                            } else {
                                selectedIngredientID = ingredient.id
                                availableAmount = ""
                                isInputFocused = true
                            }
                        }
                    } label: {
                        HStack(spacing: DS.Spacing.medium) {
                            Image(systemName: isSelected ? "scope" : "circle")
                                .font(.body)
                                .foregroundStyle(isSelected ? DS.Colors.warm : DS.Colors.textLight)
                                .contentTransition(.symbolEffect(.replace))

                            Text(ingredient.displayText)
                                .font(DS.Typography.bodyMedium)
                                .foregroundStyle(isSelected ? DS.Colors.warm : DS.Colors.textPrimary)

                            Spacer()

                            if isSelected && IngredientScaler.parseNumber(from: ingredient.amount) != nil {
                                HStack(spacing: DS.Spacing.small) {
                                    TextField("amt", text: $availableAmount)
                                        .keyboardType(.decimalPad)
                                        .focused($isInputFocused)
                                        .font(DS.Typography.labelLarge)
                                        .foregroundStyle(DS.Colors.warm)
                                        .multilineTextAlignment(.trailing)
                                        .frame(width: 56)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 5)
                                        .background(DS.Colors.warm.opacity(0.08))
                                        .clipShape(.rect(cornerRadius: 8))

                                    if !ingredient.unit.isEmpty {
                                        Text(ingredient.unit)
                                            .font(DS.Typography.bodySmall)
                                            .foregroundStyle(DS.Colors.textSoft)
                                    }
                                }
                            }
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, DS.Spacing.medium)
                        .background(isSelected ? DS.Colors.warm.opacity(0.05) : Color.clear)
                        .contentShape(Rectangle())
                    }
                    .sensoryFeedback(.selection, trigger: isSelected)
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
}
