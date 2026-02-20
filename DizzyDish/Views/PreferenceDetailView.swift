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
    @State private var newItem: String = ""

    var body: some View {
        ScrollView {
            VStack(spacing: DS.Spacing.large) {
                header
                content
                Button {
                    Task { await authStore.savePreferences() }
                } label: {
                    Text("Save")
                        .font(DS.Typography.labelLarge)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(DS.Colors.green)
                        .foregroundStyle(.white)
                        .clipShape(.rect(cornerRadius: DS.Radius.large))
                }
            }
            .padding(DS.Spacing.xl)
        }
        .background(DS.Colors.background)
        .scrollIndicators(.hidden)
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
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
            tagEditor(items: preferencesBinding(for: .dietaryNeeds), placeholder: "Add dietary need")
        case .favoriteCuisines:
            tagEditor(items: preferencesBinding(for: .favoriteCuisines), placeholder: "Add cuisine")
        case .avoidIngredients:
            tagEditor(items: preferencesBinding(for: .avoidIngredients), placeholder: "Add ingredient")
        }
    }

    private var householdOptions: some View {
        VStack(spacing: DS.Spacing.small) {
            ForEach(Household.allCases) { option in
                Button {
                    authStore.preferences.household = option
                } label: {
                    HStack {
                        Text(option.rawValue)
                            .font(DS.Typography.bodyMedium)
                        Spacer()
                        if authStore.preferences.household == option {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(DS.Colors.green)
                        }
                    }
                    .padding(DS.Spacing.medium)
                    .background(DS.Colors.card)
                    .clipShape(.rect(cornerRadius: DS.Radius.medium))
                    .overlay(
                        RoundedRectangle(cornerRadius: DS.Radius.medium)
                            .stroke(
                                authStore.preferences.household == option ? DS.Colors.green : DS.Colors.border,
                                lineWidth: 1
                            )
                    )
                    .foregroundStyle(DS.Colors.textPrimary)
                }
            }
        }
    }

    private func tagEditor(items: Binding<[String]>, placeholder: String) -> some View {
        VStack(spacing: DS.Spacing.medium) {
            HStack(spacing: DS.Spacing.small) {
                TextField(placeholder, text: $newItem)
                    .textInputAutocapitalization(.words)
                    .padding(DS.Spacing.medium)
                    .background(DS.Colors.card)
                    .clipShape(.rect(cornerRadius: DS.Radius.medium))
                    .overlay(
                        RoundedRectangle(cornerRadius: DS.Radius.medium)
                            .stroke(DS.Colors.border, lineWidth: 1)
                    )

                Button {
                    addItem(to: items)
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundStyle(DS.Colors.warm)
                }
            }

            FlowTagsView(tags: items.wrappedValue) { tag in
                remove(tag, from: items)
            }
        }
    }

    private func addItem(to items: Binding<[String]>) {
        let trimmed = newItem.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        if !items.wrappedValue.contains(trimmed) {
            items.wrappedValue.append(trimmed)
        }
        newItem = ""
    }

    private func remove(_ tag: String, from items: Binding<[String]>) {
        items.wrappedValue.removeAll { $0 == tag }
    }

    private func preferencesBinding(for route: PreferenceRoute) -> Binding<[String]> {
        Binding(
            get: {
                switch route {
                case .dietaryNeeds: return authStore.preferences.dietaryNeeds
                case .favoriteCuisines: return authStore.preferences.favoriteCuisines
                case .avoidIngredients: return authStore.preferences.avoidIngredients
                case .household: return []
                }
            },
            set: { newValue in
                switch route {
                case .dietaryNeeds:
                    authStore.preferences.dietaryNeeds = newValue
                case .favoriteCuisines:
                    authStore.preferences.favoriteCuisines = newValue
                case .avoidIngredients:
                    authStore.preferences.avoidIngredients = newValue
                case .household:
                    break
                }
            }
        )
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

struct FlowTagsView: View {
    let tags: [String]
    let onRemove: (String) -> Void

    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 110), spacing: DS.Spacing.small)], spacing: DS.Spacing.small) {
            ForEach(tags, id: \.self) { tag in
                HStack(spacing: DS.Spacing.micro) {
                    Text(tag)
                        .font(DS.Typography.bodySmall)
                    Button {
                        onRemove(tag)
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.caption)
                    }
                }
                .padding(.horizontal, DS.Spacing.medium)
                .padding(.vertical, DS.Spacing.small)
                .background(DS.Colors.warm.opacity(0.1))
                .foregroundStyle(DS.Colors.warm)
                .clipShape(.rect(cornerRadius: DS.Radius.pill))
            }
        }
    }
}
