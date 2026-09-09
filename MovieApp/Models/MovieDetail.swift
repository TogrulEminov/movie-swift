import Foundation

struct MovieDetail: Decodable, Identifiable {
    let id: Int
    let title: String
    let overview: String

    let posterPath: String?
    let backdropPath: String?

    let releaseDate: String
    let voteAverage: Double
    let voteCount: Int

    let runtime: Int?
    let genres: [Genre]

    let tagline: String?
    let status: String

    let budget: Int
    let revenue: Int

}

extension MovieDetail {

    var releaseYear: String {
        guard releaseDate.count >= 4 else {
            return "N/A"
        }

        return String(releaseDate.prefix(4))
    }

    var formattedRuntime: String {
        guard let runtime, runtime > 0 else {
            return "N/A"
        }

        let hours = runtime / 60
        let minutes = runtime % 60

        if hours == 0 {
            return "\(minutes)m"
        }

        return "\(hours)h \(minutes)m"
    }

    var genreText: String {
        genres.map(\.name).joined(separator: ", ")
    }

    var formattedBudget: String {
        formatCurrency(budget)
    }

    var formattedRevenue: String {
        formatCurrency(revenue)
    }

    private func formatCurrency(_ value: Int) -> String {
        guard value > 0 else {
            return "N/A"
        }

        return value.formatted(
            .currency(code: "USD")
            .precision(.fractionLength(0))
        )
    }
}
