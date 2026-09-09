import SwiftUI

@MainActor
struct MovieDetailView: View {

    @State private var viewModel: MovieDetailViewModel

    init(movie: Movie) {
        _viewModel = State(
            initialValue: MovieDetailViewModel(
                movie: movie
            )
        )
    }

    init(
        movie: Movie,
        networkService: any NetworkService
    ) {
        _viewModel = State(
            initialValue: MovieDetailViewModel(
                movie: movie,
                networkService: networkService
            )
        )
    }

    var body: some View {
        Group {
            switch viewModel.state {
            case .idle, .loading:
                LoadingStateView(
                    message: "Loading movie details..."
                )

            case .loaded:
                loadedContent

            case .empty:
                EmptyStateView(
                    title: "Movie not found",
                    message: "Movie details are currently unavailable."
                )

            case .error(let message):
                ErrorStateView(message: message) {
                    await viewModel.loadDetails()
                }
            }
        }
        .navigationTitle(viewModel.movie.title)
        .navigationBarTitleDisplayMode(.inline)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.background)
        .task {
            guard viewModel.state == .idle else {
                return
            }

            await viewModel.loadDetails()
        }
    }
}

extension MovieDetailView {

    @ViewBuilder
    private var loadedContent: some View {
        if let detail = viewModel.detail {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 28) {
                    headerSection(detail: detail)
                    genreSection(detail: detail)
                    overviewSection(detail: detail)
                    directorSection
                    castSection
                    financialSection(detail: detail)
                    similarMoviesSection
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 32)
            }
            .ignoresSafeArea(edges: .top)
        } else {
            EmptyStateView(
                title: "Movie not found",
                message: "Movie details are currently unavailable."
            )
        }
    }
}
extension MovieDetailView {

    private func headerSection(detail: MovieDetail) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            GeometryReader { geometry in
                ZStack(alignment: .bottomLeading) {
                    MovieBackdropView(
                        path: detail.backdropPath
                    )
                    .frame(
                        width: geometry.size.width,
                        height: 330
                    )
                    .clipped()

                    LinearGradient(
                        colors: [
                            .clear,
                            Color.black.opacity(0.25),
                            Color.black.opacity(0.95),
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(
                        width: geometry.size.width,
                        height: 330
                    )

                    headerInformation(detail: detail)
                        .frame(
                            width: geometry.size.width,
                            alignment: .leading
                        )
                }
                .frame(
                    width: geometry.size.width,
                    height: 330
                )
                .clipped()
            }
            .frame(height: 330)

            ratingSection(detail: detail)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func headerInformation(
        detail: MovieDetail
    ) -> some View {
        HStack(alignment: .bottom, spacing: 16) {
            MoviePosterView(
                path: detail.posterPath,
                size: .posterSmall
            )
            .frame(width: 105, height: 158)
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 16,
                    style: .continuous
                )
            )
            .shadow(
                color: .black.opacity(0.4),
                radius: 12,
                y: 6
            )

            VStack(alignment: .leading, spacing: 8) {
                Text(detail.title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)

                if let tagline = detail.tagline,
                    !tagline.isEmpty
                {
                    Text(tagline)
                        .font(.caption)
                        .italic()
                        .foregroundStyle(.white.opacity(0.75))
                        .lineLimit(2)
                }

                HStack(spacing: 10) {
                    Label(
                        detail.releaseYear,
                        systemImage: "calendar"
                    )

                    Label(
                        detail.formattedRuntime,
                        systemImage: "clock"
                    )
                }
                .font(.caption)
                .foregroundStyle(.white.opacity(0.85))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
    }

    private func ratingSection(
        detail: MovieDetail
    ) -> some View {
        HStack(spacing: 10) {
            RatingBadgeView(
                rating: detail.voteAverage
            )

            Text("\(detail.voteCount) votes")
                .font(.caption)
                .foregroundStyle(.secondary)

            Spacer()

            FavoriteButton(movie: viewModel.movie)
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity)
    }
}

extension MovieDetailView {

    private func genreSection(
        detail: MovieDetail
    ) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 10) {
                ForEach(detail.genres) { genre in
                    GenreChipView(genre: genre)
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

extension MovieDetailView {

    private func overviewSection(
        detail: MovieDetail
    ) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionTitle("Storyline")

            if detail.overview.isEmpty {
                Text("No overview is currently available.")
                    .foregroundStyle(.secondary)
            } else {
                Text(detail.overview)
                    .font(.body)
                    .foregroundStyle(.primary)
                    .lineSpacing(5)
                    .fixedSize(
                        horizontal: false,
                        vertical: true
                    )
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
    }
}

extension MovieDetailView {

    @ViewBuilder
    private var directorSection: some View {
        if let director = viewModel.director {
            VStack(alignment: .leading, spacing: 10) {
                sectionTitle("Director")

                HStack(spacing: 12) {
                    Image(systemName: "movieclapper")
                        .font(.title3)
                        .foregroundStyle(.orange)
                        .frame(width: 44, height: 44)
                        .background(
                            Color.orange.opacity(0.12)
                        )
                        .clipShape(Circle())

                    VStack(alignment: .leading, spacing: 3) {
                        Text(director.name)
                            .font(.headline)

                        Text("Director")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
        }
    }
}

extension MovieDetailView {

    @ViewBuilder
    private var castSection: some View {
        if !viewModel.cast.isEmpty {
            VStack(alignment: .leading, spacing: 14) {
                sectionTitle("Top Cast")
                    .padding(.horizontal, 16)

                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 14) {
                        ForEach(viewModel.cast.prefix(12)) { member in
                            CastCardView(member: member)
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

extension MovieDetailView {

    private func financialSection(
        detail: MovieDetail
    ) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            sectionTitle("Movie Information")

            HStack(spacing: 12) {
                MovieInfoItemView(
                    icon: "banknote",
                    title: "Budget",
                    value: detail.formattedBudget
                )
                .frame(maxWidth: .infinity)

                MovieInfoItemView(
                    icon: "chart.line.uptrend.xyaxis",
                    title: "Revenue",
                    value: detail.formattedRevenue
                )
                .frame(maxWidth: .infinity)
            }

            MovieInfoItemView(
                icon: "checkmark.seal",
                title: "Status",
                value: detail.status
            )
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
    }
}

extension MovieDetailView {

    @ViewBuilder
    private var similarMoviesSection: some View {
        if !viewModel.similarMovies.isEmpty {
            VStack(alignment: .leading, spacing: 14) {
                sectionTitle("You May Also Like")
                    .padding(.horizontal, 16)

                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 16) {
                        ForEach(viewModel.similarMovies) { movie in
                            NavigationLink(value: AppRoute.movieDetail(movie)) {
                                MovieCardView(
                                    movie: movie,
                                    width: 145
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

extension MovieDetailView {

    private func sectionTitle(
        _ title: String
    ) -> some View {
        Text(title)
            .font(.title3)
            .fontWeight(.bold)
            .foregroundStyle(.primary)
    }
}
#Preview("Movie Detail Loaded") {
    NavigationStack {
        MovieDetailView(
            movie: MockData.movies[0],
            networkService: MockNetworkService(
                shouldFail: false
            )
        )
    }
    .environment(FavoritesStore())
    .environment(ThemeStore())
}

#Preview("Movie Detail Error") {
    NavigationStack {
        MovieDetailView(
            movie: MockData.movies[0],
            networkService: MockNetworkService(
                shouldFail: true
            )
        )
    }
    .environment(FavoritesStore())
    .environment(ThemeStore())
}
