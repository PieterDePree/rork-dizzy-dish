import SwiftUI
import Supabase

@main
struct DizzyDishApp: App {
    @State private var savedStore = SavedRecipesStore()
    @State private var authStore = AuthStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(savedStore)
                .environment(authStore)
                .onOpenURL { url in
                    supabase.auth.handle(url)
                }
        }
    }
}
