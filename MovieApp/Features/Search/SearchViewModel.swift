import Foundation
import Observation

@MainActor
@Observable
final class SearchViewModel {

    private(set) var movies: [Movie] = []
    private(set) var state: SearchViewState = .idle
    private(set) var isLoadingNextPage = false
    private(set) var nextPageErrorMessage: String?

    var searchText = ""

    private var currentPage = 1
    private var totalPages = 1
    private var searchTask: Task<Void, Never>?

    private let networkService: any NetworkService

    init(
        networkService: any NetworkService = DefaultNetworkService()
    ) {
        self.networkService = networkService
    }

    func searchTextChanged() {
        searchTask?.cancel()

        let query = searchText.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !query.isEmpty else {
            resetSearch()
            return
        }

        state = .loading

        searchTask = Task {
            do {
                try await Task.sleep(
                    for: .milliseconds(400)
                )

                try Task.checkCancellation()

                await searchMovies(query: query)
            } catch is CancellationError {
                return
            } catch {
                state = .error(error.localizedDescription)
            }
        }
    }

    private func searchMovies(query: String) async {
        currentPage = 1
        totalPages = 1
        nextPageErrorMessage = nil

        do {
            let response: MovieResponse =
                try await networkService.request(
                    MovieEndpoint.search(
                        query: query,
                        page: currentPage
                    )
                )

            try Task.checkCancellation()

            movies = response.results
            currentPage = response.page
            totalPages = response.totalPages

            state = movies.isEmpty ? .empty : .loaded
        } catch is CancellationError {
            return
        } catch {
            state = .error(error.localizedDescription)
        }
    }

    func retrySearch() async {
        searchTask?.cancel()

        let query = searchText.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !query.isEmpty else {
            resetSearch()
            return
        }

        state = .loading
        await searchMovies(query: query)
    }

    func loadNextPageIfNeeded(
        currentMovie: Movie
    ) async {
        guard currentMovie.id == movies.last?.id else {
            return
        }

        await loadNextPage()
    }

    func retryNextPage() async {
        await loadNextPage()
    }

    private func loadNextPage() async {
        guard !isLoadingNextPage else {
            return
        }

        guard currentPage < totalPages else {
            return
        }

        let query = searchText.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !query.isEmpty else {
            return
        }

        isLoadingNextPage = true
        nextPageErrorMessage = nil

        defer {
            isLoadingNextPage = false
        }

        let nextPage = currentPage + 1

        do {
            let response: MovieResponse =
                try await networkService.request(
                    MovieEndpoint.search(
                        query: query,
                        page: nextPage
                    )
                )

            try Task.checkCancellation()

            appendUniqueMovies(response.results)

            currentPage = response.page
            totalPages = response.totalPages
        } catch is CancellationError {
            return
        } catch {
            nextPageErrorMessage = error.localizedDescription
        }
    }

    private func appendUniqueMovies(
        _ newMovies: [Movie]
    ) {
        let existingIDs = Set(movies.map(\.id))

        let uniqueMovies = newMovies.filter {
            !existingIDs.contains($0.id)
        }

        movies.append(contentsOf: uniqueMovies)
    }

    private func resetSearch() {
        searchTask?.cancel()
        movies = []
        currentPage = 1
        totalPages = 1
        nextPageErrorMessage = nil
        isLoadingNextPage = false
        state = .idle
    }

    func cancelTasks() {
        searchTask?.cancel()
        searchTask = nil
    }
}
