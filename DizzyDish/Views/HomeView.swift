import SwiftUI

struct HomeView: View {
    @State private var viewModel = HomeViewModel()
    @Environment(SavedRecipesStore.self) private var savedStore
    @Namespace private var heroNamespace

    var body: some View {
        NavigationStack {
            ZStack {
                DS.Colors.background.ignoresSafeArea()

                if viewModel.step == .result, let recipe = viewModel.currentRecipe {
                    resultView(recipe: recipe)
                        .transition(.asymmetric(
                            insertion: .scale(scale: 0.85).combined(with: .opacity),
                            removal: .scale(scale: 0.9).combined(with: .opacity)
                        ))
                } else {
                    homeMainView
                        .transition(.opacity)
                }
            }
            .animation(.spring(response: 0.55, dampingFraction: 0.85), value: viewModel.step)
        }
    }

    private var homeMainView: some View {
        ScrollView {
            VStack(spacing: DS.Spacing.xl) {
                headerContent(
                    title: "Dizzy Dish",
                    subtitle: greetingText
                )
                .padding(.top, DS.Spacing.large)

                VStack(alignment: .leading, spacing: DS.Spacing.medium) {
                    Text("HOW MUCH TIME?")
                        .font(DS.Typography.labelSmall)
                        .foregroundStyle(DS.Colors.textSoft)
                        .tracking(1)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: DS.Spacing.small) {
                            ForEach(TimeFilter.allCases) { filter in
                                FilterChip(
                                    icon: filter.icon,
                                    label: filter.label,
                                    isSelected: viewModel.selectedTimeFilter == filter
                                ) {
                                    withAnimation(.snappy) {
                                        viewModel.selectTime(filter)
                                    }
                                }
                            }
                        }
                        .contentMargins(.horizontal, DS.Spacing.xl)
                    }
                }

                VStack(alignment: .leading, spacing: DS.Spacing.medium) {
                    Text("PICK YOUR MOOD")
                        .font(DS.Typography.labelSmall)
                        .foregroundStyle(DS.Colors.textSoft)
                        .tracking(1)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: DS.Spacing.small) {
                            ForEach(VibeFilter.allCases) { filter in
                                FilterChip(
                                    icon: filter.icon,
                                    label: filter.rawValue,
                                    isSelected: viewModel.selectedVibeFilter == filter
                                ) {
                                    withAnimation(.snappy) {
                                        viewModel.selectVibe(filter)
                                    }
                                }
                            }
                        }
                        .contentMargins(.horizontal, DS.Spacing.xl)
                    }
                }

                VStack(spacing: DS.Spacing.medium) {
                    if viewModel.step == .spinning {
                        Text("Finding your dinner...")
                            .font(DS.Typography.displaySmall)
                            .foregroundStyle(DS.Colors.textPrimary)
                    } else {
                        VStack(spacing: DS.Spacing.small) {
                            Text("Give it a spin!")
                                .font(DS.Typography.displayMedium)
                                .foregroundStyle(DS.Colors.textPrimary)

                            choiceSummary
                        }
                    }

                    SpinnerWheelView(
                        rotation: viewModel.wheelRotation,
                        isSpinning: viewModel.isSpinning,
                        onSpin: { viewModel.spin() }
                    )
                    .sensoryFeedback(.impact(weight: .heavy), trigger: viewModel.spinCount)
                }
                .padding(.top, DS.Spacing.small)

            }
            .padding(.horizontal, DS.Spacing.xl)
        }
        .scrollIndicators(.hidden)
        .safeAreaInset(edge: .bottom) {
            Color.clear.frame(height: 72)
        }
    }

    private func resultView(recipe: Recipe) -> some View {
        ScrollView {
            VStack(spacing: 0) {
                resultHeroImage(recipe: recipe)

                VStack(alignment: .leading, spacing: DS.Spacing.xl) {
                    resultTitleSection(recipe: recipe)
                    resultStatsRow(recipe: recipe)
                    resultReasonCard(recipe: recipe)
                    resultActionButtons(recipe: recipe)
                }
                .padding(DS.Spacing.large + DS.Spacing.micro)
            }
        }
        .scrollIndicators(.hidden)
    }

    private func resultHeroImage(recipe: Recipe) -> some View {
        DS.Colors.cream
            .frame(height: 300)
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
            .clipShape(.rect(cornerRadii: .init(bottomLeading: DS.Radius.xl, bottomTrailing: DS.Radius.xl)))
            .overlay(alignment: .topLeading) {
                Button {
                    viewModel.startOver()
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.callout.weight(.semibold))
                        .foregroundStyle(.white)
                        .padding(10)
                        .background(.ultraThinMaterial, in: Circle())
                }
                .padding(DS.Spacing.large)
                .padding(.top, 44)
            }
            .overlay(alignment: .topTrailing) {
                Button {
                    savedStore.toggleSave(recipe)
                } label: {
                    Image(systemName: savedStore.isSaved(recipe) ? "heart.fill" : "heart")
                        .font(.callout.weight(.semibold))
                        .foregroundStyle(savedStore.isSaved(recipe) ? DS.Colors.warm : .white)
                        .padding(10)
                        .background(.ultraThinMaterial, in: Circle())
                }
                .sensoryFeedback(.impact(weight: .medium), trigger: savedStore.isSaved(recipe))
                .padding(DS.Spacing.large)
                .padding(.top, 44)
            }
    }

    private func resultTitleSection(recipe: Recipe) -> some View {
        VStack(alignment: .leading, spacing: DS.Spacing.small) {
            Text(recipe.title)
                .font(DS.Typography.displayMedium)
                .foregroundStyle(DS.Colors.textPrimary)

            Text(recipe.cuisineType)
                .font(DS.Typography.bodyMedium)
                .foregroundStyle(DS.Colors.textSoft)
        }
    }

    private func resultStatsRow(recipe: Recipe) -> some View {
        HStack(spacing: 0) {
            statItem(icon: "clock.fill", value: recipe.timeLabel, label: "Total")
            Spacer()
            statItem(icon: "person.2.fill", value: "\(recipe.servings)", label: "Servings")
            Spacer()
            statItem(icon: recipe.difficultyIcon, value: recipe.difficulty, label: "Level")
        }
        .padding(DS.Spacing.large)
        .background(DS.Colors.card)
        .clipShape(.rect(cornerRadius: DS.Radius.large))
        .overlay(
            RoundedRectangle(cornerRadius: DS.Radius.large)
                .stroke(DS.Colors.border, lineWidth: 1)
        )
    }

    private func statItem(icon: String, value: String, label: String) -> some View {
        VStack(spacing: DS.Spacing.micro) {
            Image(systemName: icon)
                .font(.callout)
                .foregroundStyle(DS.Colors.warm)
            Text(value)
                .font(DS.Typography.labelLarge)
                .foregroundStyle(DS.Colors.textPrimary)
            Text(label)
                .font(DS.Typography.caption)
                .foregroundStyle(DS.Colors.textSoft)
        }
        .frame(maxWidth: .infinity)
    }

    private func resultReasonCard(recipe: Recipe) -> some View {
        HStack(alignment: .top, spacing: DS.Spacing.medium) {
            Image(systemName: "sparkles")
                .font(.callout)
                .foregroundStyle(DS.Colors.warm)

            Text(recipe.reason)
                .font(DS.Typography.bodyMedium)
                .foregroundStyle(DS.Colors.textSoft)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(DS.Spacing.large)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(DS.Colors.warm.opacity(0.08))
        .clipShape(.rect(cornerRadius: DS.Radius.medium))
    }

    private func resultActionButtons(recipe: Recipe) -> some View {
        VStack(spacing: DS.Spacing.medium) {
            NavigationLink(value: recipe) {
                HStack(spacing: DS.Spacing.small) {
                    Image(systemName: "flame.fill")
                    Text("Let's Cook")
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(
                    LinearGradient(
                        colors: [DS.Colors.green, DS.Colors.greenLight],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .foregroundStyle(.white)
                .clipShape(.rect(cornerRadius: DS.Radius.large))
            }

            Button {
                viewModel.spinAgain()
            } label: {
                HStack(spacing: DS.Spacing.small) {
                    Image(systemName: "arrow.trianglehead.2.counterclockwise")
                    Text("Not Tonight — Spin Again")
                }
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

            Button {
                viewModel.startOver()
            } label: {
                Text("Start Over")
                    .font(DS.Typography.labelMedium)
                    .foregroundStyle(DS.Colors.textSoft)
            }
            .padding(.top, DS.Spacing.small)
        }
        .navigationDestination(for: Recipe.self) { recipe in
            RecipeDetailView(recipe: recipe)
        }
    }

    private func headerContent(title: String, subtitle: String) -> some View {
        VStack(spacing: DS.Spacing.small) {
            Text(title)
                .font(DS.Typography.displayLarge)
                .foregroundStyle(DS.Colors.textPrimary)

            Text(subtitle)
                .font(DS.Typography.bodyMedium)
                .foregroundStyle(DS.Colors.textSoft)
                .multilineTextAlignment(.center)
        }
    }

    private var choiceSummary: some View {
        HStack(spacing: DS.Spacing.small) {
            if let time = viewModel.selectedTimeFilter {
                ChoicePill(icon: time.icon, label: time.label)
            }
            if let vibe = viewModel.selectedVibeFilter {
                ChoicePill(icon: vibe.icon, label: vibe.rawValue)
            }
            if viewModel.selectedTimeFilter == nil && viewModel.selectedVibeFilter == nil {
                Text("Surprise me — no filters!")
                    .font(DS.Typography.bodySmall)
                    .foregroundStyle(DS.Colors.textSoft)
            }
        }
    }

    private var greetingText: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 0..<12: return "Good morning — let's figure out dinner."
        case 12..<17: return "Afternoon! Let's find tonight's dinner."
        default: return "Evening! Let's get something cooking."
        }
    }
}

struct FilterCard: View {
    let icon: String
    let label: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: DS.Spacing.small) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(isSelected ? DS.Colors.warm : DS.Colors.textSoft)

                Text(label)
                    .font(DS.Typography.labelMedium)
                    .foregroundStyle(isSelected ? DS.Colors.textPrimary : DS.Colors.textSoft)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 80)
            .background(isSelected ? DS.Colors.warm.opacity(0.1) : DS.Colors.card)
            .clipShape(.rect(cornerRadius: DS.Radius.large))
            .overlay(
                RoundedRectangle(cornerRadius: DS.Radius.large)
                    .stroke(isSelected ? DS.Colors.warm : DS.Colors.border, lineWidth: isSelected ? 2 : 1)
            )
        }
        .sensoryFeedback(.selection, trigger: isSelected)
    }
}

struct VibeCard: View {
    let icon: String
    let label: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: DS.Spacing.small) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundStyle(isSelected ? DS.Colors.warm : DS.Colors.textSoft)

                Text(label)
                    .font(DS.Typography.labelSmall)
                    .foregroundStyle(isSelected ? DS.Colors.textPrimary : DS.Colors.textSoft)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 72)
            .background(isSelected ? DS.Colors.warm.opacity(0.1) : DS.Colors.card)
            .clipShape(.rect(cornerRadius: DS.Radius.medium))
            .overlay(
                RoundedRectangle(cornerRadius: DS.Radius.medium)
                    .stroke(isSelected ? DS.Colors.warm : DS.Colors.border, lineWidth: isSelected ? 2 : 1)
            )
        }
        .sensoryFeedback(.selection, trigger: isSelected)
    }
}

struct ChoicePill: View {
    let icon: String
    let label: String

    var body: some View {
        HStack(spacing: DS.Spacing.micro) {
            Image(systemName: icon)
                .font(.caption)
            Text(label)
                .font(DS.Typography.labelSmall)
        }
        .padding(.horizontal, DS.Spacing.medium)
        .padding(.vertical, DS.Spacing.small)
        .background(DS.Colors.warm.opacity(0.12))
        .foregroundStyle(DS.Colors.warm)
        .clipShape(Capsule())
    }
}

struct FilterChip: View {
    let icon: String
    let label: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: DS.Spacing.small) {
                Image(systemName: icon)
                    .font(DS.Typography.bodySmall)
                Text(label)
                    .font(DS.Typography.labelMedium)
            }
            .padding(.horizontal, DS.Spacing.medium)
            .padding(.vertical, 10)
            .background(
                Capsule()
                    .fill(isSelected ? DS.Colors.warm.opacity(0.12) : DS.Colors.card)
            )
            .overlay(
                Capsule()
                    .stroke(isSelected ? DS.Colors.warm : DS.Colors.border, lineWidth: 1.5)
            )
            .foregroundStyle(isSelected ? DS.Colors.warm : DS.Colors.textPrimary)
        }
        .sensoryFeedback(.selection, trigger: isSelected)
    }
}
