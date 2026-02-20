import SwiftUI

struct RecipeScalerView: View {
    let recipe: Recipe
    @Environment(\.dismiss) private var dismiss
    @State private var selectedIngredientID: String?
    @State private var availableAmount: String = ""
    @FocusState private var isInputFocused: Bool

    private var scaleFactor: Double? {
        guard let selected = recipe.ingredients.first(where: { $0.id == selectedIngredientID }),
              let original = parseNumber(from: selected.amount),
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
                    scaledIngredientsSection
                }
                .padding(DS.Spacing.large + DS.Spacing.micro)
            }
            .scrollIndicators(.hidden)
            .background(DS.Colors.background)
            .navigationTitle("Scale Recipe")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .fontWeight(.semibold)
                        .foregroundStyle(DS.Colors.warm)
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

                            if isSelected && parseNumber(from: ingredient.amount) != nil {
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

    private var scaledIngredientsSection: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.medium) {
            if let factor = scaleFactor {
                HStack(spacing: DS.Spacing.small) {
                    Image(systemName: "arrow.up.arrow.down")
                        .foregroundStyle(DS.Colors.warm)
                    Text("Scaled to \(formatPercent(factor))")
                        .font(DS.Typography.displaySmall)
                        .foregroundStyle(DS.Colors.textPrimary)
                }

                let scaledServings = max(1, Int(round(Double(recipe.servings) * factor)))
                Text("\(scaledServings) serving\(scaledServings == 1 ? "" : "s")")
                    .font(DS.Typography.bodySmall)
                    .foregroundStyle(DS.Colors.textSoft)

                VStack(spacing: 2) {
                    ForEach(recipe.ingredients) { ingredient in
                        let isConstraint = ingredient.id == selectedIngredientID
                        HStack(spacing: DS.Spacing.medium) {
                            Image(systemName: isConstraint ? "scope" : "circle.fill")
                                .font(.caption2)
                                .foregroundStyle(isConstraint ? DS.Colors.warm : DS.Colors.textLight)

                            Text(scaledDisplayText(for: ingredient, factor: factor))
                                .font(DS.Typography.bodyMedium)
                                .foregroundStyle(isConstraint ? DS.Colors.warm : DS.Colors.textPrimary)
                                .fontWeight(isConstraint ? .semibold : .regular)

                            Spacer()

                            if let original = parseNumber(from: ingredient.amount), original > 0 {
                                let scaled = original * factor
                                let diff = scaled - original
                                if abs(diff) > 0.01 {
                                    Text(diff < 0 ? formatAmount(diff) : "+\(formatAmount(diff))")
                                        .font(DS.Typography.caption)
                                        .foregroundStyle(diff < 0 ? DS.Colors.warm : DS.Colors.green)
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 2)
                                        .background((diff < 0 ? DS.Colors.warm : DS.Colors.green).opacity(0.1))
                                        .clipShape(Capsule())
                                }
                            }
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, DS.Spacing.medium)
                    }
                }
                .background(DS.Colors.card)
                .clipShape(.rect(cornerRadius: DS.Radius.medium))
                .overlay(
                    RoundedRectangle(cornerRadius: DS.Radius.medium)
                        .stroke(DS.Colors.border, lineWidth: 1)
                )
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
        .animation(.snappy, value: scaleFactor != nil)
    }

    private func scaledDisplayText(for ingredient: Ingredient, factor: Double) -> String {
        guard let original = parseNumber(from: ingredient.amount), original > 0 else {
            return ingredient.displayText
        }
        let scaled = original * factor
        let amountStr = formatAmount(scaled)
        if ingredient.unit.isEmpty {
            return "\(amountStr) \(ingredient.name)"
        }
        return "\(amountStr) \(ingredient.unit) \(ingredient.name)"
    }

    private func parseNumber(from string: String) -> Double? {
        let trimmed = string.trimmingCharacters(in: .whitespaces)

        if trimmed.contains("/") {
            let parts = trimmed.split(separator: " ")
            if parts.count == 2, let whole = Double(parts[0]) {
                if let frac = parseFraction(String(parts[1])) {
                    return whole + frac
                }
            }
            return parseFraction(trimmed)
        }

        return Double(trimmed)
    }

    private func parseFraction(_ str: String) -> Double? {
        let parts = str.split(separator: "/")
        guard parts.count == 2,
              let num = Double(parts[0]),
              let den = Double(parts[1]),
              den != 0 else { return nil }
        return num / den
    }

    private func formatAmount(_ value: Double) -> String {
        let abs = abs(value)
        if abs == floor(abs) {
            return value < 0 ? "-\(Int(abs))" : "\(Int(abs))"
        }

        let common: [(Double, String)] = [
            (0.25, "¼"), (0.33, "⅓"), (0.5, "½"), (0.67, "⅔"), (0.75, "¾")
        ]
        let whole = Int(abs)
        let frac = abs - Double(whole)

        for (val, symbol) in common {
            if Swift.abs(frac - val) < 0.05 {
                let prefix = value < 0 ? "-" : ""
                return whole > 0 ? "\(prefix)\(whole) \(symbol)" : "\(prefix)\(symbol)"
            }
        }

        let rounded = (value * 100).rounded() / 100
        if rounded == floor(rounded) {
            return "\(Int(rounded))"
        }
        return String(format: "%.2g", value)
    }

    private func formatPercent(_ factor: Double) -> String {
        let percent = Int(round(factor * 100))
        return "\(percent)%"
    }
}
