import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house.fill") {
                HomeView()
            }

            Tab("Saved", systemImage: "heart.fill") {
                SavedRecipesView()
            }

            Tab("You", systemImage: "person.fill") {
                ProfileView()
            }
        }
        .tint(DS.Colors.warm)
    }
}
