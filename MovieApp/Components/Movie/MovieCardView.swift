import SwiftUI

struct MovieCardView: View {

    let movie: Movie
    var width: CGFloat = 150

    private var safeWidth: CGFloat {
        guard width.isFinite, width > 0 else {
            return 150
        }

        return width
    }

    private var posterSection: some View {
        ZStack(alignment: .topLeading) {
            MoviePosterView(
                path: movie.posterPath,
                size: .posterSmall
            )

            RatingBadgeView(
                rating: movie.voteAverage
            )
            .padding(8)
        }
        .frame(
            width: safeWidth,
            height: safeWidth * 1.5
        )
        .background(
            Color.secondary.opacity(0.12)
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 18,
                style: .continuous
            )
        )
        .shadow(
            color: .black.opacity(0.12),
            radius: 10,
            y: 5
        )
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 9) {
            posterSection

            Text(movie.title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
                .lineLimit(1)

            HStack(spacing: 5) {
                Image(systemName: "calendar")
                    .font(.caption2)

                Text(movie.releaseYear)
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .frame(
            width: safeWidth,
            alignment: .leading
        )
        .contentShape(Rectangle())
        .accessibilityElement(children: .combine)
        .accessibilityLabel(
            "\(movie.title), \(movie.releaseYear), rating \(movie.voteAverage)"
        )
    }
}
