import Foundation

enum MovieCategory: String, CaseIterable, Identifiable, Hashable {
    case popular
    case topRated
    case upcoming
    case nowPlaying

    var id: Self {
        self
    }

    var title: String {
        switch self {
        case .popular: return "Popular"
        case .topRated: return "Top Rated"
        case .upcoming: return "Upcoming"
        case .nowPlaying: return "Now Playing"
        }
    }

    func endpoint(page: Int) -> MovieEndpoint {
        switch self {
        case .popular: return .popular(page: page)
        case .topRated: return .topRated(page: page)
        case .upcoming: return .upcoming(page: page)
        case .nowPlaying: return .nowPlaying(page: page)
        }
    }
}
