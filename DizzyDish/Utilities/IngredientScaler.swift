import Foundation

enum IngredientScaler {
    static func parseNumber(from string: String) -> Double? {
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

    static func parseFraction(_ str: String) -> Double? {
        let parts = str.split(separator: "/")
        guard parts.count == 2,
              let num = Double(parts[0]),
              let den = Double(parts[1]),
              den != 0 else { return nil }
        return num / den
    }

    static func formatAmount(_ value: Double) -> String {
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

    static func scaledDisplayText(for ingredient: Ingredient, factor: Double) -> String {
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
}
