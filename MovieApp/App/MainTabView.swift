import SwiftUI

struct MainTabView: View {

    var body: some View {
        TabView {
            homeTab
            searchTab
            favoritesTab
        }
        .tint(AppColors.accent)
    }
}
extension MainTabView {

    private var homeTab: some View {
        NavigationStack {
            HomeView()
                .navigationDestination(
                    for: AppRoute.self
                ) { route in
                    destination(for: route)
                }
        }
        .tabItem {
            Label(
                "Home",
                systemImage: "house.fill"
            )
        }
    }

    private var searchTab: some View {
        NavigationStack {
            SearchView()
                .navigationDestination(
                    for: AppRoute.self
                ) { route in
                    destination(for: route)
                }
        }
        .tabItem {
            Label(
                "Search",
                systemImage: "magnifyingglass"
            )
        }
    }

    private var favoritesTab: some View {
        NavigationStack {
            FavoritesView()
                .navigationDestination(
                    for: AppRoute.self
                ) { route in
                    destination(for: route)
                }
        }
        .tabItem {
            Label(
                "Favorites",
                systemImage: "heart.fill"
            )
        }
    }
}

extension MainTabView {

    @ViewBuilder
    private func destination(
        for route: AppRoute
    ) -> some View {
        switch route {
        case .movieList(let category):
            MovieListView(category: category)

        case .movieDetail(let movie):
            MovieDetailView(movie: movie)
        }
    }
}
