 import Foundation
import Observation

@MainActor
@Observable

final class MovieDetailViewModel {
    let movie: Movie

    private(set) var detail: MovieDetail?
    private(set) var cast: [CastMember] = []
    private(set) var director: CrewMember?
    private(set) var similarMovies: [Movie] = []

    private(set) var state: MovieDetailViewState = .idle

    private let networkService: any NetworkService

    init(
        movie: Movie,
        networkService: any NetworkService = DefaultNetworkService()
    ) {
        self.movie = movie
        self.networkService = networkService
    }

    func loadDetails() async {
        guard state != .loading else { return }

        state = .loading
        do {
            async let detailResponse: MovieDetail = networkService.request(
                MovieEndpoint.detail(id: movie.id)
            )
            async let creditResponse: CreditsResponse = networkService.request(
                MovieEndpoint.credits(id: movie.id)
            )
            async let similarResponse: MovieResponse = networkService.request(
                MovieEndpoint.similar(id: movie.id, page: 1)
            )

            let (movieDetail, credits, similar) = try await (
                detailResponse, creditResponse, similarResponse
            )
            detail = movieDetail
            cast = credits.cast.sorted { $0.order < $1.order }
            director = credits.crew.first(where: { $0.job == "Director" })
            similarMovies = similar.results.filter({ $0.id != movie.id })

            state = .loaded
        } catch is CancellationError {
            state = .idle
        } catch {
            state = .error(error.localizedDescription)
        }
    }
}
