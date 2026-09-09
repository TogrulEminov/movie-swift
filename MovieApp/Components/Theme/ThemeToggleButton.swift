//
//  ThemeToggleButton.swift
//  MovieApp
//
//  Created by Eminov Togrul Punhan on 09.09.26.
//
import SwiftUI

struct ThemeToggleButton: View {
    @Environment(ThemeStore.self) private var themeStore
    var body: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.3)) {
                themeStore.toggleTheme()
            }
        } label: {
            Image(
                systemName: themeStore.isDarkMode ? "sun.max.fill" : "moon.fill"
            )
        }.font(.title3).foregroundStyle(
            themeStore.isDarkMode
                ? Color.yellow
                : Color.indigo
        ).frame(width: 38, height: 38)
            .background(.ultraThinMaterial)
            .clipShape(Circle())
            .buttonStyle(.plain)
            .accessibilityLabel(
                themeStore.isDarkMode
                    ? "Switch to light mode"
                    : "Switch to dark mode"
            )

    }
}
