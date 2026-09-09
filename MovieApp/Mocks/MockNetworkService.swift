import Foundation

final class MockNetworkService: NetworkService {

    let shouldFail: Bool

    init(shouldFail: Bool = false) {
        self.shouldFail = shouldFail
    }

    func request<T: Decodable>(
        _ endpoint: any Endpoint
    ) async throws -> T {
        if shouldFail {
            throw MockNetworkError.forcedFailure
        }

        guard
            let movieEndpoint =
                endpoint as? MovieEndpoint
        else {
            throw MockNetworkError.unsupportedEndpoint
        }

        let response: Any

        switch movieEndpoint {
        case .detail:
            response = MockData.movieDetail

        case .credits:
            response = MockData.creditsResponse

        case .popular,
            .topRated,
            .upcoming,
            .nowPlaying,
            .similar,
            .search:
            response = MockData.movieResponse
        }

        guard let typedResponse = response as? T else {
            throw MockNetworkError.invalidResponseType
        }

        return typedResponse
    }
}
