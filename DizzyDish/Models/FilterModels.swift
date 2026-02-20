import Foundation

nonisolated enum TimeFilter: String, CaseIterable, Identifiable, Sendable {
    case fifteen = "15"
    case thirty = "30"
    case fortyFive = "45"
    case sixtyPlus = "60+"

    var id: String { rawValue }

    var label: String {
        switch self {
        case .fifteen: return "15 min"
        case .thirty: return "30 min"
        case .fortyFive: return "45 min"
        case .sixtyPlus: return "60+ min"
        }
    }

    var icon: String {
        switch self {
        case .fifteen: return "bolt.fill"
        case .thirty: return "frying.pan.fill"
        case .fortyFive: return "flame.fill"
        case .sixtyPlus: return "fork.knife"
        }
    }

    var maxMinutes: Int {
        switch self {
        case .fifteen: return 15
        case .thirty: return 30
        case .fortyFive: return 45
        case .sixtyPlus: return 999
        }
    }
}

nonisolated enum VibeFilter: String, CaseIterable, Identifiable, Sendable {
    case lazy = "Lazy"
    case healthy = "Healthy"
    case comfort = "Comfort"
    case spicy = "Spicy"
    case fancy = "Fancy"
    case adventurous = "Adventurous"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .lazy: return "sofa.fill"
        case .healthy: return "heart.fill"
        case .comfort: return "cup.and.saucer.fill"
        case .spicy: return "flame.fill"
        case .fancy: return "sparkles"
        case .adventurous: return "dice.fill"
        }
    }
}
