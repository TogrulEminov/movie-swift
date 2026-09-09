import Foundation

enum MovieDetailViewState:Equatable {
    case idle
    case loading
    case loaded
    case empty
    case error(String)
}


