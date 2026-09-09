import SwiftUI

@MainActor

struct MovieListView: View {
    @State private var vm: MovieListViewModel

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
    ]
    init(category: MovieCategory) {
        _vm = State(
            initialValue: MovieListViewModel(
                category: category
            )
        )
    }

    init(
        category: MovieCategory,
        networkService: any NetworkService
    ) {
        _vm = State(
            initialValue: MovieListViewModel(
                category: category,
                networkService: networkService
            )
        )
    }

    private var movieGrid: some View {
        GeometryReader { geometry in
            let horizontalPadding: CGFloat = 16
            let columnSpacing: CGFloat = 16

            let availableWidth = max(
                geometry.size.width
                    - horizontalPadding * 2
                    - columnSpacing,
                0
            )

            let cardWidth = max(
                availableWidth / 2,
                1
            )
            ScrollView {
                LazyVGrid(columns: columns, spacing: 24) {
                    ForEach(vm.movies) { movie in
                        NavigationLink(value: AppRoute.movieDetail(movie)) {
                            MovieCardView(movie: movie, width: cardWidth)
                        }
                        .buttonStyle(.plain)
                        .task {
                            await vm.loadNextPageIfNeeded(currentMovie: movie)
                        }
                    }
                }
                .padding(.horizontal, horizontalPadding)
                .padding(.top, 16)

                paginationFooter.padding(.vertical, 24)
            }.refreshable {
                await vm.loadMovies()
            }
        }
    }

    var body: some View {
        Group {
            switch vm.state {
            case .idle, .loading:
                LoadingStateView(message: "Loading \(vm.category.title)...")
            case .loaded: movieGrid
            case .error(let message):
                ErrorStateView(message: message) {
                    await vm.loadMovies()
                }
            case .empty:
                EmptyStateView(
                    title: "No movies found",
                    message: "This category currently has no movies"
                )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.background)
        .navigationTitle(vm.category.title).navigationBarTitleDisplayMode(
            .inline
        ).task {
            guard vm.state == .idle else {
                return
            }
            await vm.loadMovies()
        }
    }
}
#Preview("Movie List Loaded") {
    NavigationStack {
        MovieListView(
            category: .popular,
            networkService: MockNetworkService(
                shouldFail: false
            )
        )
    }
    .environment(FavoritesStore())
    .environment(ThemeStore())
}
extension MovieListView {
    @ViewBuilder
    private var paginationFooter: some View {
        if vm.isLoadingNextPage {
            ProgressView().controlSize(.regular)
        } else if let message = vm.nextPageErrorMessage {
            VStack {
                Text(message).font(.caption).foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                Button("Try again") {
                    Task {
                        await vm.retryNextPage()
                    }
                }.buttonStyle(.bordered)
            }.padding(.horizontal)
        }
    }
}

#Preview("Movie List Error") {
    NavigationStack {
        MovieListView(
            category: .popular,
            networkService: MockNetworkService(
                shouldFail: true
            )
        )
    }
    .environment(FavoritesStore())
    .environment(ThemeStore())
}
