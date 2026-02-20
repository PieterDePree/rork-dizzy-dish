import SwiftUI
import Supabase

struct AuthView: View {
    @Environment(AuthStore.self) private var authStore
    @State private var email: String = ""
    @State private var password: String = ""

    var body: some View {
        ScrollView {
            VStack(spacing: DS.Spacing.xl) {
                header
                credentialsCard
                oauthButtons
                if let error = authStore.errorMessage {
                    Text(error)
                        .font(DS.Typography.bodySmall)
                        .foregroundStyle(DS.Colors.warm)
                        .multilineTextAlignment(.center)
                }
            }
            .padding(DS.Spacing.xl)
        }
        .background(DS.Colors.background)
        .scrollIndicators(.hidden)
    }

    private var header: some View {
        VStack(spacing: DS.Spacing.small) {
            Text("Welcome back")
                .font(DS.Typography.displayMedium)
                .foregroundStyle(DS.Colors.textPrimary)
            Text("Save preferences and pick up where you left off.")
                .font(DS.Typography.bodyMedium)
                .foregroundStyle(DS.Colors.textSoft)
                .multilineTextAlignment(.center)
        }
    }

    private var credentialsCard: some View {
        VStack(spacing: DS.Spacing.medium) {
            VStack(spacing: DS.Spacing.small) {
                TextField("Email", text: $email)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .keyboardType(.emailAddress)
                    .padding(DS.Spacing.medium)
                    .background(DS.Colors.card)
                    .clipShape(.rect(cornerRadius: DS.Radius.medium))
                    .overlay(
                        RoundedRectangle(cornerRadius: DS.Radius.medium)
                            .stroke(DS.Colors.border, lineWidth: 1)
                    )

                SecureField("Password", text: $password)
                    .textInputAutocapitalization(.never)
                    .padding(DS.Spacing.medium)
                    .background(DS.Colors.card)
                    .clipShape(.rect(cornerRadius: DS.Radius.medium))
                    .overlay(
                        RoundedRectangle(cornerRadius: DS.Radius.medium)
                            .stroke(DS.Colors.border, lineWidth: 1)
                    )
            }

            Button {
                Task { await authStore.signIn(email: email, password: password) }
            } label: {
                Text("Sign In")
                    .font(DS.Typography.labelLarge)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(
                        LinearGradient(
                            colors: [DS.Colors.warm, DS.Colors.warmLight],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .foregroundStyle(.white)
                    .clipShape(.rect(cornerRadius: DS.Radius.large))
            }
            .disabled(authStore.isWorking)

            Button {
                Task { await authStore.signUp(email: email, password: password) }
            } label: {
                Text("Create account")
                    .font(DS.Typography.labelLarge)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(DS.Colors.card)
                    .foregroundStyle(DS.Colors.textPrimary)
                    .clipShape(.rect(cornerRadius: DS.Radius.large))
                    .overlay(
                        RoundedRectangle(cornerRadius: DS.Radius.large)
                            .stroke(DS.Colors.border, lineWidth: 1)
                    )
            }
            .disabled(authStore.isWorking)
        }
        .padding(DS.Spacing.large)
        .background(DS.Colors.card)
        .clipShape(.rect(cornerRadius: DS.Radius.xl))
        .overlay(
            RoundedRectangle(cornerRadius: DS.Radius.xl)
                .stroke(DS.Colors.border, lineWidth: 1)
        )
    }

    private var oauthButtons: some View {
        VStack(spacing: DS.Spacing.small) {
            Button {
                Task { await authStore.signInWithOAuth(provider: .apple) }
            } label: {
                HStack(spacing: DS.Spacing.small) {
                    Image(systemName: "applelogo")
                    Text("Continue with Apple")
                        .font(DS.Typography.labelLarge)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(DS.Colors.textPrimary)
                .foregroundStyle(.white)
                .clipShape(.rect(cornerRadius: DS.Radius.large))
            }
            .disabled(authStore.isWorking)

            Button {
                Task { await authStore.signInWithOAuth(provider: .google) }
            } label: {
                HStack(spacing: DS.Spacing.small) {
                    Image(systemName: "g.circle.fill")
                    Text("Continue with Google")
                        .font(DS.Typography.labelLarge)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(DS.Colors.card)
                .foregroundStyle(DS.Colors.textPrimary)
                .clipShape(.rect(cornerRadius: DS.Radius.large))
                .overlay(
                    RoundedRectangle(cornerRadius: DS.Radius.large)
                        .stroke(DS.Colors.border, lineWidth: 1)
                )
            }
            .disabled(authStore.isWorking)
        }
    }
}
