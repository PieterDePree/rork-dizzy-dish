import Foundation
import Supabase

@Observable
class AuthStore {
    var session: Session?
    var userEmail: String = ""
    var preferences: UserPreferences = .empty
    var errorMessage: String?
    var isWorking: Bool = false

    init() {
        Task {
            let authChanges = supabase.auth.authStateChanges
            for await (_, session) in authChanges {
                self.session = session
                self.userEmail = session?.user.email ?? ""
                if let metadata = session?.user.userMetadata {
                    self.applyMetadata(metadata)
                } else {
                    self.preferences = .empty
                }
            }
        }
    }

    func signIn(email: String, password: String) async {
        await performAuthAction {
            try await supabase.auth.signIn(email: email, password: password)
        }
    }

    func signUp(email: String, password: String) async {
        await performAuthAction {
            try await supabase.auth.signUp(email: email, password: password)
        }
    }

    func signOut() async {
        await performAuthAction {
            try await supabase.auth.signOut()
        }
    }

    func signInWithOAuth(provider: Provider) async {
        await performAuthAction {
            _ = try await supabase.auth.signInWithOAuth(provider: provider)
        }
    }

    func savePreferences() async {
        let metadata: [String: AnyJSON] = [
            "household": .string(preferences.household.rawValue),
            "dietaryNeeds": .array(preferences.dietaryNeeds.map { .string($0) }),
            "favoriteCuisines": .array(preferences.favoriteCuisines.map { .string($0) }),
            "avoidIngredients": .array(preferences.avoidIngredients.map { .string($0) })
        ]

        await performAuthAction {
            _ = try await supabase.auth.update(user: UserAttributes(data: metadata))
        }
    }

    private func applyMetadata(_ metadata: [String: AnyJSON]) {
        var updated = preferences
        if let householdValue = metadata["household"]?.stringValue,
           let household = Household(rawValue: householdValue) {
            updated.household = household
        }
        if let dietary = metadata["dietaryNeeds"]?.stringArrayValue {
            updated.dietaryNeeds = dietary
        }
        if let cuisines = metadata["favoriteCuisines"]?.stringArrayValue {
            updated.favoriteCuisines = cuisines
        }
        if let avoids = metadata["avoidIngredients"]?.stringArrayValue {
            updated.avoidIngredients = avoids
        }
        preferences = updated
    }

    private func performAuthAction(_ action: @escaping () async throws -> Void) async {
        errorMessage = nil
        isWorking = true
        defer { isWorking = false }
        do {
            try await action()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
