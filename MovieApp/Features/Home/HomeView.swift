import SwiftUI

@MainActor
struct HomeView: View {
    @State private var viewModel: HomeViewModel

    init() {
        _viewModel = State(
            initialValue: HomeViewModel()
        )
    }

    init(networkService: any NetworkService) {
        _viewModel = State(
            initialValue: HomeViewModel(
                networkService: networkService
            )
        )
    }

    var body: some View {
        Group {
            switch viewModel.state {
            case .idle, .loading:
                LoadingStateView()
            case .loaded: homeContent
            case .empty: EmptyStateView()
            case .error(let message):
                ErrorStateView(message: message) {
                    await viewModel.loadMovies()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.background)
        .navigationTitle("Movies")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                ThemeToggleButton()
            }
        }
        .navigationBarTitleDisplayMode(.large)
        .task {
            guard viewModel.state == .idle else { return }
            await viewModel.loadMovies()
        }

    }

}
extension HomeView {
    private var homeContent: some View {
        ScrollView {
            LazyVStack(spacing: 30) {
                movieSection(
                    category: .popular,
                    movies: viewModel.popularMovies
                )
                movieSection(
                    category: .topRated,
                    movies: viewModel.topRatedMovies
                )
                movieSection(
                    category: .nowPlaying,
                    movies: viewModel.nowPlayingMovies
                )
                movieSection(
                    category: .upcoming,
                    movies: viewModel.upcomingMovies
                )
            }

        }
        .refreshable {
            await viewModel.refreshMovies()
        }
        .background(AppColors.background)
    }
}
extension HomeView {
    private func movieSection(category: MovieCategory, movies: [Movie])
        -> some View
    {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeaderView(title: category.title, category: category)
                .padding(.horizontal)
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    ForEach(movies) { movie in
                        NavigationLink(value: AppRoute.movieDetail(movie)) {
                            MovieCardView(movie: movie)
                        }.buttonStyle(.plain)
                    }
                }.padding(.horizontal)
            }
        }
    }
}
#Preview("Home Loaded") {
    NavigationStack {
        HomeView(
            networkService: MockNetworkService(
                shouldFail: false
            )
        )
    }
    .environment(FavoritesStore())
    .environment(ThemeStore())
}

#Preview("Home Error") {
    NavigationStack {
        HomeView(
            networkService: MockNetworkService(
                shouldFail: true
            )
        )
    }
    .environment(FavoritesStore())
    .environment(ThemeStore())
}
