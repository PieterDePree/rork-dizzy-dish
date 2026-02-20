import SwiftUI

struct ProfileView: View {
    @Environment(SavedRecipesStore.self) private var savedStore
    @Environment(AuthStore.self) private var authStore

    var body: some View {
        NavigationStack {
            Group {
                if authStore.session == nil {
                    AuthView()
                } else {
                    ScrollView {
                        VStack(spacing: DS.Spacing.xl) {
                            profileHeader
                            statsSection
                            settingsSection
                            signOutSection
                            aboutSection
                        }
                        .padding(DS.Spacing.large + DS.Spacing.micro)
                    }
                }
            }
            .background(DS.Colors.background)
            .scrollContentBackground(.hidden)
            .navigationTitle("You")
            .scrollIndicators(.hidden)
            .navigationDestination(for: PreferenceRoute.self) { route in
                PreferenceDetailView(route: route)
            }
        }
    }

    private var profileHeader: some View {
        VStack(spacing: DS.Spacing.medium) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [DS.Colors.warm.opacity(0.2), DS.Colors.warmLight.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)

                Image(systemName: "person.crop.circle.fill")
                    .font(.system(size: 44))
                    .foregroundStyle(DS.Colors.warm)
            }

            Text(authStore.userEmail.isEmpty ? "Home Chef" : authStore.userEmail)
                .font(DS.Typography.titleLarge)
                .foregroundStyle(DS.Colors.textPrimary)

            Text("Free Plan")
                .font(DS.Typography.labelSmall)
                .foregroundStyle(DS.Colors.textSoft)
                .padding(.horizontal, DS.Spacing.medium)
                .padding(.vertical, DS.Spacing.micro)
                .background(DS.Colors.warmPale)
                .clipShape(Capsule())
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, DS.Spacing.small)
    }

    private var statsSection: some View {
        HStack(spacing: 0) {
            statBox(value: "\(savedStore.savedRecipes.count)", label: "Saved")
            statBox(value: "0", label: "Cooked")
            statBox(value: "0", label: "Spins")
        }
        .background(DS.Colors.card)
        .clipShape(.rect(cornerRadius: DS.Radius.large))
        .overlay(
            RoundedRectangle(cornerRadius: DS.Radius.large)
                .stroke(DS.Colors.border, lineWidth: 1)
        )
    }

    private func statBox(value: String, label: String) -> some View {
        VStack(spacing: DS.Spacing.micro) {
            Text(value)
                .font(DS.Typography.displayMedium)
                .foregroundStyle(DS.Colors.textPrimary)
            Text(label)
                .font(DS.Typography.bodySmall)
                .foregroundStyle(DS.Colors.textSoft)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, DS.Spacing.large)
    }

    private var settingsSection: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.medium) {
            Text("Preferences")
                .font(DS.Typography.titleMedium)
                .foregroundStyle(DS.Colors.textPrimary)

            VStack(spacing: 1) {
                NavigationLink(value: PreferenceRoute.household) {
                    settingsRow(icon: "person.2.fill", title: "Household", value: authStore.preferences.household.rawValue)
                }
                NavigationLink(value: PreferenceRoute.dietaryNeeds) {
                    settingsRow(icon: "leaf.fill", title: "Dietary Needs", value: authStore.preferences.dietaryNeeds.isEmpty ? "None" : "\(authStore.preferences.dietaryNeeds.count)")
                }
                NavigationLink(value: PreferenceRoute.favoriteCuisines) {
                    settingsRow(icon: "globe", title: "Favorite Cuisines", value: authStore.preferences.favoriteCuisines.isEmpty ? "All" : "\(authStore.preferences.favoriteCuisines.count)")
                }
                NavigationLink(value: PreferenceRoute.avoidIngredients) {
                    settingsRow(icon: "xmark.circle", title: "Ingredients to Avoid", value: authStore.preferences.avoidIngredients.isEmpty ? "None" : "\(authStore.preferences.avoidIngredients.count)")
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

    private func settingsRow(icon: String, title: String, value: String) -> some View {
        HStack {
            Image(systemName: icon)
                .font(.callout)
                .foregroundStyle(DS.Colors.warm)
                .frame(width: 28)

            Text(title)
                .font(DS.Typography.bodyMedium)
                .foregroundStyle(DS.Colors.textPrimary)

            Spacer()

            Text(value)
                .font(DS.Typography.bodyMedium)
                .foregroundStyle(DS.Colors.textSoft)

            Image(systemName: "chevron.right")
                .font(.caption2.weight(.semibold))
                .foregroundStyle(DS.Colors.textLight)
        }
        .padding(.horizontal, DS.Spacing.medium)
        .padding(.vertical, DS.Spacing.medium)
        .contentShape(Rectangle())
    }

    private var signOutSection: some View {
        Button {
            Task { await authStore.signOut() }
        } label: {
            Text("Sign Out")
                .font(DS.Typography.labelLarge)
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(DS.Colors.card)
                .foregroundStyle(DS.Colors.textPrimary)
                .clipShape(.rect(cornerRadius: DS.Radius.medium))
                .overlay(
                    RoundedRectangle(cornerRadius: DS.Radius.medium)
                        .stroke(DS.Colors.border, lineWidth: 1)
                )
        }
    }

    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.medium) {
            Text("About")
                .font(DS.Typography.titleMedium)
                .foregroundStyle(DS.Colors.textPrimary)

            VStack(spacing: 1) {
                settingsRow(icon: "questionmark.circle", title: "Help & Support", value: "")
                settingsRow(icon: "star.fill", title: "Rate Dizzy Dish", value: "")
                settingsRow(icon: "doc.text", title: "Privacy Policy", value: "")
            }
            .background(DS.Colors.card)
            .clipShape(.rect(cornerRadius: DS.Radius.medium))
            .overlay(
                RoundedRectangle(cornerRadius: DS.Radius.medium)
                    .stroke(DS.Colors.border, lineWidth: 1)
            )

            Text("Version 1.0.0")
                .font(DS.Typography.caption)
                .foregroundStyle(DS.Colors.textLight)
                .frame(maxWidth: .infinity)
        }
    }
}
