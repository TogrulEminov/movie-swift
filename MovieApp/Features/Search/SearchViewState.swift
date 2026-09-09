import Foundation

enum SearchViewState:Equatable {
    case idle
    case loading
    case loaded
    case empty
    case error(String)
}
