import Foundation
import Observation

@MainActor
@Observable
final class HomeViewModel {
    private(set) var popularMovies: [Movie] = []
    private(set) var topRatedMovies: [Movie] = []
    private(set) var upcomingMovies: [Movie] = []
    private(set) var nowPlayingMovies: [Movie] = []

    private(set) var state: HomeViewState = .idle
    private var isFetching = false

    private let networkService: any NetworkService
    init(networkService: any NetworkService = DefaultNetworkService()) {

        self.networkService = networkService
    }

    func loadMovies() async {
        state = .loading
        await fetchMovies()
    }
    func refreshMovies() async {
        await fetchMovies()
    }
    private func fetchMovies() async {
        guard !isFetching else { return }
        isFetching = true

        defer {
            isFetching = false
        }

        do {
            async let popularResponse: MovieResponse = networkService.request(
                MovieEndpoint.popular(page: 1)
            )
            async let topRatedResponse: MovieResponse = networkService.request(
                MovieEndpoint.topRated(page: 1)
            )
            async let upcomingResponse: MovieResponse = networkService.request(
                MovieEndpoint.upcoming(page: 1)
            )
            async let nowPlayingResponse: MovieResponse =
                networkService.request(
                    MovieEndpoint.nowPlaying(page: 1)
                )
            let (
                popular,
                topRated,
                upcoming,
                nowPlaying
            ) = try await (
                popularResponse,
                topRatedResponse,
                upcomingResponse,
                nowPlayingResponse
            )

            popularMovies = popular.results
            topRatedMovies = topRated.results
            upcomingMovies = upcoming.results
            nowPlayingMovies = nowPlaying.results

            let allSectionAreEmpty =
                popularMovies.isEmpty && topRatedMovies.isEmpty
                && upcomingMovies.isEmpty && nowPlayingMovies.isEmpty

            state = allSectionAreEmpty ? .empty : .loaded

        } catch is CancellationError {
            return
        } catch {
            state = .error(error.localizedDescription)
        }
    }
}
