import Foundation
import Observation

@MainActor
@Observable
final class MovieListViewModel {
    private(set) var movies: [Movie] = []
    private(set) var state: MovieListViewState = .idle
    private(set) var isLoadingNextPage = false
    private(set) var nextPageErrorMessage: String?

    private var currentPage = 1
    private var totalPages = 1

    let category: MovieCategory

    private var networkService: any NetworkService

    init(
        category: MovieCategory,
        networkService: any NetworkService = DefaultNetworkService()
    ) {
        self.category = category
        self.networkService = networkService
    }

    func loadMovies() async {
        guard state != .loading else {
            return
        }

        state = .loading
        currentPage = 1
        totalPages = 1
        nextPageErrorMessage = nil
        do {
            let response: MovieResponse = try await networkService.request(
                category.endpoint(page: currentPage)
            )

            movies = response.results
            currentPage = response.page
            totalPages = response.totalPages
            state = movies.isEmpty ? .empty : .loaded

        } catch is CancellationError {
            state = .idle
        } catch {
            state = .error(error.localizedDescription)
        }

    }

    func loadNextPageIfNeeded(currentMovie: Movie) async {
        guard currentMovie.id == movies.last?.id else {
            return
        }
        await loadNextPage()
    }
    func retryNextPage() async {
        await loadNextPage()
    }

    private func loadNextPage() async {
        guard !isLoadingNextPage else { return }
        guard currentPage < totalPages else { return }
        isLoadingNextPage = true
        nextPageErrorMessage = nil
        defer {
            isLoadingNextPage = false
        }
        let nextPage = currentPage + 1

        do {
            let response: MovieResponse = try await networkService.request(
                category.endpoint(page: nextPage)
            )

            movies.append(contentsOf: response.results)
            currentPage = response.page
            totalPages = response.totalPages
        } catch is CancellationError {
            return
        } catch {
            nextPageErrorMessage = error.localizedDescription
        }
    }
}
