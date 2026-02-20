import SwiftUI

enum DS {

    enum Colors {
        static let background = Color(hex: 0xFAF8F1)
        static let card = Color.white
        static let cream = Color(hex: 0xF1E8D5)
        static let warm = Color(hex: 0xCA6E3D)
        static let warmLight = Color(hex: 0xE8B68E)
        static let warmPale = Color(hex: 0xF0F0E6)
        static let green = Color(hex: 0x4A7C59)
        static let greenLight = Color(hex: 0x6B9C7A)
        static let instacart = Color(hex: 0x1DBF1D)
        static let textPrimary = Color(hex: 0x2D2A26)
        static let textSoft = Color(hex: 0x8C8170)
        static let textLight = Color(hex: 0xB8B0AA)
        static let border = Color(hex: 0xE8E3DD)
    }

    enum Spacing {
        static let micro: CGFloat = 4
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
        static let xl: CGFloat = 24
    }

    enum Radius {
        static let small: CGFloat = 12
        static let medium: CGFloat = 14
        static let large: CGFloat = 20
        static let xl: CGFloat = 28
        static let pill: CGFloat = 50
    }

    enum Typography {
        static func display(size: CGFloat, weight: Font.Weight = .bold) -> Font {
            .system(size: size, weight: weight, design: .serif)
        }

        static func body(size: CGFloat, weight: Font.Weight = .regular) -> Font {
            .system(size: size, weight: weight, design: .default)
        }

        static let displayLarge = display(size: 32, weight: .bold)
        static let displayMedium = display(size: 24, weight: .bold)
        static let displaySmall = display(size: 20, weight: .semibold)

        static let titleLarge = body(size: 20, weight: .semibold)
        static let titleMedium = body(size: 17, weight: .semibold)

        static let bodyLarge = body(size: 17, weight: .regular)
        static let bodyMedium = body(size: 15, weight: .regular)
        static let bodySmall = body(size: 13, weight: .regular)

        static let labelLarge = body(size: 15, weight: .semibold)
        static let labelMedium = body(size: 13, weight: .semibold)
        static let labelSmall = body(size: 11, weight: .medium)

        static let caption = body(size: 11, weight: .regular)
    }

    enum Animation {
        static let calmPulse = SwiftUI.Animation.easeInOut(duration: 2.0).repeatForever(autoreverses: true)
        static let gentleUp = SwiftUI.Animation.spring(response: 0.5, dampingFraction: 0.8)
        static let slideUp = SwiftUI.Animation.spring(response: 0.6, dampingFraction: 0.85)
        static let spinWheel = SwiftUI.Animation.timingCurve(0.15, 0.85, 0.25, 1.0, duration: 3.5)
    }
}

extension Color {
    init(hex: UInt, opacity: Double = 1.0) {
        self.init(
            red: Double((hex >> 16) & 0xFF) / 255.0,
            green: Double((hex >> 8) & 0xFF) / 255.0,
            blue: Double(hex & 0xFF) / 255.0,
            opacity: opacity
        )
    }
}
