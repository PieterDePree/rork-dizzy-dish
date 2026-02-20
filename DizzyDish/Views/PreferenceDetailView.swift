import SwiftUI

enum PreferenceRoute: Hashable {
    case household
    case dietaryNeeds
    case favoriteCuisines
    case avoidIngredients
}

struct PreferenceDetailView: View {
    let route: PreferenceRoute
    @Environment(AuthStore.self) private var authStore
    @Environment(\.dismiss) private var dismiss
    @State private var newItem: String = ""
    @State private var showSaved: Bool = false
    @State private var hasChanges: Bool = false

    var body: some View {
        ScrollView {
            VStack(spacing: DS.Spacing.xl) {
                header
                content
            }
            .padding(DS.Spacing.xl)
        }
        .background(DS.Colors.background)
        .scrollIndicators(.hidden)
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if hasChanges {
                    Button {
                        Task {
                            await authStore.savePreferences()
                            withAnimation(.spring(response: 0.4)) {
                                showSaved = true
                                hasChanges = false
                            }
                            try? await Task.sleep(for: .seconds(1.5))
                            withAnimation { showSaved = false }
                        }
                    } label: {
                        Text("Save")
                            .font(DS.Typography.labelLarge)
                            .foregroundStyle(DS.Colors.warm)
                    }
                }
            }
        }
        .overlay(alignment: .top) {
            if showSaved {
                savedBanner
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
    }

    private var savedBanner: some View {
        HStack(spacing: DS.Spacing.small) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(DS.Colors.green)
            Text("Saved")
                .font(DS.Typography.labelMedium)
                .foregroundStyle(DS.Colors.textPrimary)
        }
        .padding(.horizontal, DS.Spacing.large)
        .padding(.vertical, DS.Spacing.medium)
        .background(.ultraThinMaterial)
        .clipShape(Capsule())
        .shadow(color: .black.opacity(0.08), radius: 12, y: 4)
        .padding(.top, DS.Spacing.small)
    }

    private var header: some View {
        Text(subtitle)
            .font(DS.Typography.bodyMedium)
            .foregroundStyle(DS.Colors.textSoft)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    @ViewBuilder
    private var content: some View {
        switch route {
        case .household:
            householdOptions
        case .dietaryNeeds:
            suggestionGrid(
                suggestions: PreferenceSuggestions.dietaryNeeds,
                selected: authStore.preferences.dietaryNeeds,
                toggle: toggleDietary,
                placeholder: "Add custom dietary need"
            )
        case .favoriteCuisines:
            suggestionGrid(
                suggestions: PreferenceSuggestions.cuisines,
                selected: authStore.preferences.favoriteCuisines,
                toggle: toggleCuisine,
                placeholder: "Add custom cuisine"
            )
        case .avoidIngredients:
            suggestionGrid(
                suggestions: PreferenceSuggestions.avoidIngredients,
                selected: authStore.preferences.avoidIngredients,
                toggle: toggleAvoid,
                placeholder: "Add custom ingredient"
            )
        }
    }

    private var householdOptions: some View {
        VStack(spacing: DS.Spacing.small) {
            ForEach(Household.allCases) { option in
                let isSelected = authStore.preferences.household == option
                Button {
                    withAnimation(.spring(response: 0.35)) {
                        authStore.preferences.household = option
                        hasChanges = true
                    }
                } label: {
                    HStack(spacing: DS.Spacing.medium) {
                        ZStack {
                            Circle()
                                .fill(isSelected ? DS.Colors.warm.opacity(0.12) : DS.Colors.warmPale)
                                .frame(width: 44, height: 44)
                            Image(systemName: option.icon)
                                .font(.system(size: 18, weight: .medium))
                                .foregroundStyle(isSelected ? DS.Colors.warm : DS.Colors.textSoft)
                        }

                        VStack(alignment: .leading, spacing: 2) {
                            Text(option.rawValue)
                                .font(DS.Typography.labelLarge)
                                .foregroundStyle(DS.Colors.textPrimary)
                            Text(option.subtitle)
                                .font(DS.Typography.bodySmall)
                                .foregroundStyle(DS.Colors.textSoft)
                        }

                        Spacer()

                        if isSelected {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.title3)
                                .foregroundStyle(DS.Colors.green)
                                .transition(.scale.combined(with: .opacity))
                        }
                    }
                    .padding(DS.Spacing.medium)
                    .background(DS.Colors.card)
                    .clipShape(.rect(cornerRadius: DS.Radius.medium))
                    .overlay(
                        RoundedRectangle(cornerRadius: DS.Radius.medium)
                            .stroke(isSelected ? DS.Colors.warm.opacity(0.4) : DS.Colors.border, lineWidth: isSelected ? 1.5 : 1)
                    )
                }
                .sensoryFeedback(.selection, trigger: authStore.preferences.household)
            }
        }
    }

    private func suggestionGrid(
        suggestions: [(String, String)],
        selected: [String],
        toggle: @escaping (String) -> Void,
        placeholder: String
    ) -> some View {
        VStack(alignment: .leading, spacing: DS.Spacing.xl) {
            VStack(alignment: .leading, spacing: DS.Spacing.medium) {
                Text("Suggestions")
                    .font(DS.Typography.labelMedium)
                    .foregroundStyle(DS.Colors.textSoft)

                FlowLayout(spacing: DS.Spacing.small) {
                    ForEach(suggestions, id: \.0) { name, icon in
                        let isActive = selected.contains(name)
                        Button {
                            withAnimation(.spring(response: 0.3)) {
                                toggle(name)
                                hasChanges = true
                            }
                        } label: {
                            HStack(spacing: DS.Spacing.micro) {
                                Image(systemName: icon)
                                    .font(.caption)
                                Text(name)
                                    .font(DS.Typography.labelMedium)
                            }
                            .padding(.horizontal, DS.Spacing.medium)
                            .padding(.vertical, DS.Spacing.small + 2)
                            .background(isActive ? DS.Colors.warm.opacity(0.12) : DS.Colors.card)
                            .foregroundStyle(isActive ? DS.Colors.warm : DS.Colors.textPrimary)
                            .clipShape(Capsule())
                            .overlay(
                                Capsule()
                                    .stroke(isActive ? DS.Colors.warm.opacity(0.3) : DS.Colors.border, lineWidth: 1)
                            )
                        }
                        .sensoryFeedback(.selection, trigger: isActive)
                    }
                }
            }

            let customItems = selected.filter { item in
                !suggestions.contains { $0.0 == item }
            }

            if !customItems.isEmpty {
                VStack(alignment: .leading, spacing: DS.Spacing.medium) {
                    Text("Custom")
                        .font(DS.Typography.labelMedium)
                        .foregroundStyle(DS.Colors.textSoft)

                    FlowLayout(spacing: DS.Spacing.small) {
                        ForEach(customItems, id: \.self) { item in
                            HStack(spacing: DS.Spacing.micro) {
                                Text(item)
                                    .font(DS.Typography.labelMedium)
                                Button {
                                    withAnimation(.spring(response: 0.3)) {
                                        toggle(item)
                                        hasChanges = true
                                    }
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.caption)
                                }
                            }
                            .padding(.horizontal, DS.Spacing.medium)
                            .padding(.vertical, DS.Spacing.small + 2)
                            .background(DS.Colors.warm.opacity(0.12))
                            .foregroundStyle(DS.Colors.warm)
                            .clipShape(Capsule())
                        }
                    }
                }
            }

            VStack(alignment: .leading, spacing: DS.Spacing.small) {
                Text("Add Your Own")
                    .font(DS.Typography.labelMedium)
                    .foregroundStyle(DS.Colors.textSoft)

                HStack(spacing: DS.Spacing.small) {
                    TextField(placeholder, text: $newItem)
                        .textInputAutocapitalization(.words)
                        .submitLabel(.done)
                        .onSubmit { addCustomItem(toggle: toggle) }
                        .padding(DS.Spacing.medium)
                        .background(DS.Colors.card)
                        .clipShape(.rect(cornerRadius: DS.Radius.medium))
                        .overlay(
                            RoundedRectangle(cornerRadius: DS.Radius.medium)
                                .stroke(DS.Colors.border, lineWidth: 1)
                        )

                    Button {
                        addCustomItem(toggle: toggle)
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundStyle(newItem.trimmingCharacters(in: .whitespaces).isEmpty ? DS.Colors.textLight : DS.Colors.warm)
                    }
                    .disabled(newItem.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }

    private func addCustomItem(toggle: (String) -> Void) {
        let trimmed = newItem.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        toggle(trimmed)
        hasChanges = true
        newItem = ""
    }

    private func toggleDietary(_ item: String) {
        if let idx = authStore.preferences.dietaryNeeds.firstIndex(of: item) {
            authStore.preferences.dietaryNeeds.remove(at: idx)
        } else {
            authStore.preferences.dietaryNeeds.append(item)
        }
    }

    private func toggleCuisine(_ item: String) {
        if let idx = authStore.preferences.favoriteCuisines.firstIndex(of: item) {
            authStore.preferences.favoriteCuisines.remove(at: idx)
        } else {
            authStore.preferences.favoriteCuisines.append(item)
        }
    }

    private func toggleAvoid(_ item: String) {
        if let idx = authStore.preferences.avoidIngredients.firstIndex(of: item) {
            authStore.preferences.avoidIngredients.remove(at: idx)
        } else {
            authStore.preferences.avoidIngredients.append(item)
        }
    }

    private var title: String {
        switch route {
        case .household: return "Household"
        case .dietaryNeeds: return "Dietary Needs"
        case .favoriteCuisines: return "Favorite Cuisines"
        case .avoidIngredients: return "Ingredients to Avoid"
        }
    }

    private var subtitle: String {
        switch route {
        case .household: return "Tell us who you're cooking for most nights."
        case .dietaryNeeds: return "Add any dietary requirements or allergies."
        case .favoriteCuisines: return "Highlight the cuisines you love most."
        case .avoidIngredients: return "List ingredients you prefer to avoid."
        }
    }
}

struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = layout(proposal: proposal, subviews: subviews)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = layout(proposal: proposal, subviews: subviews)
        for (index, position) in result.positions.enumerated() {
            subviews[index].place(
                at: CGPoint(x: bounds.minX + position.x, y: bounds.minY + position.y),
                proposal: .unspecified
            )
        }
    }

    private func layout(proposal: ProposedViewSize, subviews: Subviews) -> (size: CGSize, positions: [CGPoint]) {
        let maxWidth = proposal.width ?? .infinity
        var positions: [CGPoint] = []
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > maxWidth, x > 0 {
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }
            positions.append(CGPoint(x: x, y: y))
            rowHeight = max(rowHeight, size.height)
            x += size.width + spacing
        }

        return (CGSize(width: maxWidth, height: y + rowHeight), positions)
    }
}
