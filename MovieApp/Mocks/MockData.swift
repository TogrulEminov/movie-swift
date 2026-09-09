import Foundation

enum MockData {

    static let movies: [Movie] = [
        Movie(
            id: 1,
            title: "Interstellar",
            overview: """
                A team of explorers travels through a wormhole in space
                in an attempt to ensure humanity's survival.
                """,
            posterPath: "/gEU2QniE6E77NI6lCU6MxlNBvIx.jpg",
            backdropPath: "/xJHokMbljvjADYdit5fK5VQsXEG.jpg",
            releaseDate: "2014-11-05",
            voteAverage: 8.4,
            voteCount: 36000,
            genreIds: [12, 18, 878]
        ),

        Movie(
            id: 2,
            title: "The Dark Knight",
            overview: """
                Batman faces a criminal mastermind who plunges Gotham
                City into chaos.
                """,
            posterPath: "/qJ2tW6WMUDux911r6m7haRef0WH.jpg",
            backdropPath: "/nMKdUUepR0i5zn0y1T4CsSB5chy.jpg",
            releaseDate: "2008-07-16",
            voteAverage: 8.5,
            voteCount: 33000,
            genreIds: [18, 28, 80]
        ),

        Movie(
            id: 3,
            title: "Inception",
            overview: """
                A skilled thief enters people's dreams to steal
                valuable secrets.
                """,
            posterPath: "/oYuLEt3zVCKq57qu2F8dT7NIa6f.jpg",
            backdropPath: "/s3TBrRGB1iav7gFOCNx3H31MoES.jpg",
            releaseDate: "2010-07-15",
            voteAverage: 8.4,
            voteCount: 37000,
            genreIds: [28, 878, 12]
        ),
    ]

    static let movieResponse = MovieResponse(
        page: 1,
        results: movies,
        totalPages: 1,
        totalResults: movies.count
    )

    static let movieDetail = MovieDetail(
        id: 1,
        title: "Interstellar",
        overview: """
            A team of explorers travels through a wormhole in space
            in an attempt to ensure humanity's survival.
            """,
        posterPath: "/gEU2QniE6E77NI6lCU6MxlNBvIx.jpg",
        backdropPath: "/xJHokMbljvjADYdit5fK5VQsXEG.jpg",
        releaseDate: "2014-11-05",
        voteAverage: 8.4,
        voteCount: 36000,
        runtime: 169,
        genres: [
            Genre(id: 12, name: "Adventure"),
            Genre(id: 18, name: "Drama"),
            Genre(id: 878, name: "Science Fiction"),
        ],
        tagline: "Mankind was born on Earth. It was never meant to die here.",
        status: "Released",
        budget: 165_000_000,
        revenue: 731_000_000
    )

    static let creditsResponse = CreditsResponse(
        id: 1,
        cast: [
            CastMember(
                id: 1,
                name: "Matthew McConaughey",
                character: "Cooper",
                profilePath: nil,
                order: 0
            ),

            CastMember(
                id: 2,
                name: "Anne Hathaway",
                character: "Brand",
                profilePath: nil,
                order: 1
            ),

            CastMember(
                id: 3,
                name: "Jessica Chastain",
                character: "Murph",
                profilePath: nil,
                order: 2
            ),
        ],
        crew: [
            CrewMember(
                id: 10,
                name: "Christopher Nolan",
                job: "Director",
                department: "Directing"
            )
        ]
    )
}
