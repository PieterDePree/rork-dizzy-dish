import Foundation
import Supabase

extension AnyJSON {
    var stringValue: String? {
        if case let .string(value) = self {
            return value
        }
        return nil
    }

    var stringArrayValue: [String]? {
        if case let .array(values) = self {
            return values.compactMap { value in
                if case let .string(string) = value {
                    return string
                }
                return nil
            }
        }
        return nil
    }
}
