import Observation
import SwiftUI

@MainActor
@Observable

final class ThemeStore {
    private static let storageKey = "isDarkMode"
    var isDarkMode: Bool {
        didSet {
            UserDefaults.standard.set(isDarkMode, forKey: Self.storageKey)
        }
    }
    init() {
        isDarkMode = UserDefaults.standard.bool(forKey: Self.storageKey)
    }
    var colorScheme: ColorScheme {
        isDarkMode ? .dark : .light
    }
    func toggleTheme() {
        isDarkMode.toggle()
    }
}
