import SwiftUI

enum HomeStep: Equatable {
    case time
    case vibe
    case spin
    case spinning
    case result
}

@Observable
class HomeViewModel {
    var step: HomeStep = .time
    var selectedTimeFilter: TimeFilter?
    var selectedVibeFilter: VibeFilter?
    var currentRecipe: Recipe?
    var isSpinning: Bool = false
    var spinCount: Int = 0
    var wheelRotation: Double = 0

    func selectTime(_ filter: TimeFilter) {
        if selectedTimeFilter == filter {
            selectedTimeFilter = nil
        } else {
            selectedTimeFilter = filter
        }
    }

    func selectVibe(_ filter: VibeFilter) {
        if selectedVibeFilter == filter {
            selectedVibeFilter = nil
        } else {
            selectedVibeFilter = filter
        }
    }

    func advanceToVibe() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) {
            step = .vibe
        }
    }

    func advanceToSpin() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) {
            step = .spin
        }
    }

    func goBack() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) {
            switch step {
            case .vibe: step = .time
            case .spin: step = .vibe
            default: break
            }
        }
    }

    func decideForMe() {
        selectedTimeFilter = nil
        selectedVibeFilter = nil
        withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) {
            step = .spin
        }
    }

    func spin() {
        guard !isSpinning else { return }
        isSpinning = true
        spinCount += 1

        withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) {
            step = .spinning
        }

        let extraSpins = Double.random(in: 6...10) * 360
        let randomOffset = Double.random(in: 0..<360)
        let target = wheelRotation + extraSpins + randomOffset

        withAnimation(DS.Animation.spinWheel) {
            wheelRotation = target
        }

        Task {
            try? await Task.sleep(for: .seconds(3.8))
            let recipe = RecipeService.fetchRecipe(
                timeFilter: selectedTimeFilter,
                vibeFilter: selectedVibeFilter
            )
            currentRecipe = recipe
            isSpinning = false
            withAnimation(.spring(response: 0.6, dampingFraction: 0.82)) {
                step = .result
            }
        }
    }

    func spinAgain() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) {
            step = .spin
        }
        Task {
            try? await Task.sleep(for: .milliseconds(500))
            spin()
        }
    }

    func startOver() {
        currentRecipe = nil
        selectedTimeFilter = nil
        selectedVibeFilter = nil
        withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) {
            step = .time
        }
    }
}
