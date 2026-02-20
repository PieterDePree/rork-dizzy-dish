import Foundation
import Supabase

let supabase: SupabaseClient = {
    let urlString = ProcessInfo.processInfo.environment["SUPABASE_URL"] ?? ""
    let anonKey = ProcessInfo.processInfo.environment["SUPABASE_ANON_KEY"] ?? ""
    let url = URL(string: urlString) ?? URL(string: "https://invalid.supabase.co")!
    let key = anonKey.isEmpty ? "invalid" : anonKey
    return SupabaseClient(supabaseURL: url, supabaseKey: key)
}()

enum SupabaseRedirect {
    static var scheme: String? {
        ProcessInfo.processInfo.environment["SUPABASE_REDIRECT_SCHEME"]
    }

    static var callbackURL: URL? {
        guard let scheme else { return nil }
        return URL(string: "\(scheme)://login-callback")
    }
}
