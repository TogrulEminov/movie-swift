import SwiftUI

@main
struct MovieAppApp: App {
    @State private var favoritesStore = FavoritesStore()
    @State private var themeStore = ThemeStore()
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(favoritesStore)
                .environment(themeStore)
                .preferredColorScheme(themeStore.colorScheme)
        }
    }
}
