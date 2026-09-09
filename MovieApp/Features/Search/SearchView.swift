import SwiftUI

@MainActor
struct SearchView: View {
    @State private var viewModel: SearchViewModel

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
    ]
    init() {
        _viewModel = State(
            initialValue: SearchViewModel()
        )
    }

    init(viewModel: SearchViewModel) {
        _viewModel = State(
            initialValue: viewModel
        )
    }

    init(
        networkService: any NetworkService,
        initialSearchText: String
    ) {
        let viewModel = SearchViewModel(
            networkService: networkService
        )

        viewModel.searchText = initialSearchText

        _viewModel = State(
            initialValue: viewModel
        )
    }

    var body: some View {
        @Bindable var viewModel = viewModel

        Group {
            switch viewModel.state {
            case .idle: initialContent
            case .loading: LoadingStateView(message: "Searching movies..")
            case .loaded: searchResults
            case .empty:
                ContentUnavailableView.search(text: viewModel.searchText)
            case .error(let message):
                ErrorStateView(message: message) {
                    await viewModel.retrySearch()
                }
            }
        }
        .navigationTitle("Search")
        .navigationBarTitleDisplayMode(.large)
        .searchable(
            text: $viewModel.searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Search movies"
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.background)
        .onChange(of: viewModel.searchText) {
            viewModel.searchTextChanged()
        }
        .onDisappear {
            viewModel.cancelTasks()
        }
        .task {
            let query = viewModel.searchText.trimmingCharacters(
                in: .whitespacesAndNewlines
            )

            guard viewModel.state == .idle,
                !query.isEmpty
            else {
                return
            }

            viewModel.searchTextChanged()
        }
    }
}
extension SearchView {
    private var searchResults: some View {
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
                    ForEach(viewModel.movies) { movie in
                        NavigationLink(value: AppRoute.movieDetail(movie)) {
                            MovieCardView(movie: movie, width: cardWidth)
                        }.buttonStyle(.plain).task {
                            await viewModel.loadNextPageIfNeeded(
                                currentMovie: movie
                            )
                        }
                    }
                }.padding(.horizontal, horizontalPadding).padding(.top, 16)

                paginationFooter
                    .padding(.vertical, 24)
            }
        }
    }
}
extension SearchView {
    private var initialContent: some View {
        ContentUnavailableView {
            Label("Search movies", systemImage: "magnifyingglass")
        } description: {
            Text("Search for movies by entering a title")
        }
    }
}
extension SearchView {

    @ViewBuilder
    private var paginationFooter: some View {
        if viewModel.isLoadingNextPage {
            ProgressView()
                .controlSize(.regular)
        } else if let message =
            viewModel.nextPageErrorMessage
        {
            VStack(spacing: 10) {
                Text(message)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)

                Button("Try again") {
                    Task {
                        await viewModel.retryNextPage()
                    }
                }
                .buttonStyle(.bordered)
            }
            .padding(.horizontal, 16)
        }
    }
}
#Preview("Search Loaded") {
    NavigationStack {
        SearchView(
            networkService: MockNetworkService(
                shouldFail: false
            ),
            initialSearchText: "Interstellar"
        )
    }
    .environment(FavoritesStore())
    .environment(ThemeStore())
}

#Preview("Search Error") {
    NavigationStack {
        SearchView(
            networkService: MockNetworkService(
                shouldFail: true
            ),
            initialSearchText: "Interstellar"
        )
    }
    .environment(FavoritesStore())
    .environment(ThemeStore())
}
