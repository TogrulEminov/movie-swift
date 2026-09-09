import Foundation

struct Movie: Hashable, Identifiable, Codable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String
    let voteAverage: Double
    let voteCount: Int
    let genreIds: [Int]
}
extension Movie {
    var releaseYear: String {
        guard releaseDate.count >= 4 else {
            return "N/A"
        }
        return String(releaseDate.prefix(4))

    }
}
