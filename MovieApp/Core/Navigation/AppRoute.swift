import Foundation

enum AppRoute: Hashable {
    case movieList(MovieCategory)
    case movieDetail(Movie)
}
