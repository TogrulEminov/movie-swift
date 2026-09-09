import SwiftUI

struct FavoritesView: View {

    @Environment(FavoritesStore.self)
    private var favoritesStore

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
    ]

    var body: some View {
        Group {
            if favoritesStore.movies.isEmpty {
                emptyContent
            } else {
                favoritesGrid
            }
        }
        .navigationTitle("Favorites")
        .navigationBarTitleDisplayMode(.large)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.background)
        .alert(
            "Something went wrong",
            isPresented: errorBinding
        ) {
            Button("OK", role: .cancel) {
                favoritesStore.clearError()
            }
        } message: {
            Text(favoritesStore.errorMessage ?? "")
        }
    }
}

extension FavoritesView {

    private var emptyContent: some View {
        ContentUnavailableView {
            Label(
                "No Favorites",
                systemImage: "heart.slash"
            )
        } description: {
            Text(
                "Movies you add to favorites will appear here."
            )
        }
    }
}
extension FavoritesView {

    private var favoritesGrid: some View {
        GeometryReader { geometry in
            let horizontalPadding: CGFloat = 16
            let columnSpacing: CGFloat = 16

            let availableWidth = max(
                geometry.size.width
                    - horizontalPadding * 2
                    - columnSpacing,
                0
            )

            let cardWidth = max(
                availableWidth / 2,
                1
            )

            ScrollView {
                LazyVGrid(
                    columns: columns,
                    spacing: 24
                ) {
                    ForEach(favoritesStore.movies) { movie in
                        favoriteItem(
                            movie: movie,
                            width: cardWidth
                        )
                    }
                }
                .padding(.horizontal, horizontalPadding)
                .padding(.top, 16)
                .padding(.bottom, 32)
            }
        }
    }

    private func favoriteItem(
        movie: Movie,
        width: CGFloat
    ) -> some View {
        ZStack(alignment: .topTrailing) {
            NavigationLink(value: AppRoute.movieDetail(movie)) {
                MovieCardView(
                    movie: movie,
                    width: width
                )
            }
            .buttonStyle(.plain)

            Button {
                withAnimation {
                    favoritesStore.remove(movie)
                }
            } label: {
                Image(systemName: "heart.fill")
                    .font(.subheadline)
                    .foregroundStyle(.white)
                    .padding(9)
                    .background(.red)
                    .clipShape(Circle())
                    .shadow(
                        color: .black.opacity(0.2),
                        radius: 5,
                        y: 3
                    )
            }
            .padding(8)
            .accessibilityLabel(
                "Remove \(movie.title) from favorites"
            )
        }
    }
}
extension FavoritesView {

    private var errorBinding: Binding<Bool> {
        Binding(
            get: {
                favoritesStore.errorMessage != nil
            },
            set: { isPresented in
                if !isPresented {
                    favoritesStore.clearError()
                }
            }
        )
    }
}
#Preview("Favorites Loaded") {
    NavigationStack {
        FavoritesView()
    }
    .environment(
        FavoritesStore(
            previewMovies: MockData.movies
        )
    )
    .environment(ThemeStore())
}

#Preview("Favorites Error") {
    NavigationStack {
        FavoritesView()
    }
    .environment(
        FavoritesStore(
            previewMovies: [],
            previewErrorMessage:
                "Favorites could not be loaded."
        )
    )
    .environment(ThemeStore())
}
