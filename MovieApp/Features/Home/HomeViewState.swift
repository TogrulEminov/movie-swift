import Foundation

enum HomeViewState: Equatable {
    case idle
    case loading
    case loaded
    case empty
    case error(String)
}
