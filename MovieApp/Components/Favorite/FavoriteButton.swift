import SwiftUI

struct FavoriteButton: View {

    @Environment(FavoritesStore.self)
    private var favoritesStore

    let movie: Movie

    private var isFavorite: Bool {
        favoritesStore.contains(movie)
    }

    var body: some View {
        Button {
            withAnimation(
                .spring(
                    response: 0.4,
                    dampingFraction: 0.6
                )
            ) {
                favoritesStore.toggle(movie)
            }
        } label: {
            Image(
                systemName: isFavorite
                    ? "heart.fill"
                    : "heart"
            )
            .font(.title3)
            .foregroundStyle(
                isFavorite ? Color.red : Color.primary
            )
            .frame(width: 44, height: 44)
            .background(.ultraThinMaterial)
            .clipShape(Circle())
            .overlay {
                Circle()
                    .stroke(
                        Color.primary.opacity(0.08),
                        lineWidth: 1
                    )
            }
            .scaleEffect(isFavorite ? 1.08 : 1)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(
            isFavorite
                ? "Remove from favorites"
                : "Add to favorites"
        )
        .accessibilityValue(
            isFavorite ? "Favorite" : "Not favorite"
        )
    }
}
