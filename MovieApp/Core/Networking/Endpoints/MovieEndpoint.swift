import Foundation

enum MovieEndpoint {
    case popular(page: Int)
    case topRated(page: Int)
    case upcoming(page: Int)
    case nowPlaying(page: Int)

    case detail(id: Int)
    case credits(id: Int)
    case similar(id: Int, page: Int)

    case search(query: String, page: Int)
}

extension MovieEndpoint: Endpoint {
    var path: String {
        switch self {
        case .popular:
            return "/movie/popular"

        case .topRated:
            return "/movie/top_rated"

        case .upcoming:
            return "/movie/upcoming"

        case .nowPlaying:
            return "/movie/now_playing"

        case .detail(let id):
            return "/movie/\(id)"

        case .credits(let id):
            return "/movie/\(id)/credits"

        case .similar(let id, _):
            return "/movie/\(id)/similar"

        case .search:
            return "/search/movie"
        }
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case .popular(let page),
            .topRated(let page),
            .upcoming(let page),
            .nowPlaying(let page),
            .similar(_, let page):

            return makePageQueryItems(page: page)

        case .search(let query, let page):
            return [
                URLQueryItem(
                    name: "query",
                    value: query
                ),
                URLQueryItem(
                    name: "page",
                    value: String(page)
                ),
                URLQueryItem(
                    name: "include_adult",
                    value: "false"
                ),
            ]

        case .detail, .credits:
            return nil
        }
    }
}

extension MovieEndpoint {
    private func makePageQueryItems(
        page: Int
    ) -> [URLQueryItem] {
        [
            URLQueryItem(
                name: "page",
                value: String(page)
            )
        ]
    }
}
