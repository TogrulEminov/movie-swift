import Foundation
import Observation

@MainActor
@Observable

final class FavoritesStore {
    private(set) var movies: [Movie] = []
    private(set) var errorMessage: String?
    private let fileManager: FileManager
    private let isPersistenceEnabled: Bool
    private let fileURL: URL

    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
        self.isPersistenceEnabled = true

        let documentsDirectory = fileManager.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )

        let directory =
            documentsDirectory.first
            ?? fileManager.temporaryDirectory

        self.fileURL =
            directory
            .appendingPathComponent("favorites.json")

        loadFavorites()
    }

    init(
        previewMovies: [Movie],
        previewErrorMessage: String? = nil
    ) {
        let fileManager = FileManager.default

        self.fileManager = fileManager
        self.isPersistenceEnabled = false

        self.fileURL = fileManager.temporaryDirectory
            .appendingPathComponent(
                "favorites-preview.json"
            )

        self.movies = previewMovies
        self.errorMessage = previewErrorMessage
    }

    func contains(_ movie: Movie) -> Bool {
        movies.contains { $0.id == movie.id }
    }

    func toggle(_ movie: Movie) {
        let previousMovies = movies
        if let index = movies.firstIndex(where: { $0.id == movie.id }) {
            movies.remove(at: index)
        } else {
            movies.insert(movie, at: 0)
        }

        do {
            try saveFavorites()
            errorMessage = nil
        } catch {
            movies = previousMovies
            errorMessage = error.localizedDescription
        }
    }

    private func loadFavorites() {
        guard fileManager.fileExists(atPath: fileURL.path) else { return }

        do {
            let data = try Data(contentsOf: fileURL)

            movies = try JSONDecoder().decode([Movie].self, from: data)

            errorMessage = nil
        } catch {
            movies = []
            errorMessage = error.localizedDescription
        }
    }
    func saveFavorites() throws {
        let encoder = JSONEncoder()
        let data = try encoder.encode(movies)

        try data.write(to: fileURL, options: .atomic)
    }
    func clearError() {
        errorMessage = nil
    }
    func remove(_ movie: Movie) {
        guard let index = movies.firstIndex(where: { $0.id == movie.id }) else {
            return
        }
        let previousMovies = movies

        movies.remove(at: index)

        do {
            try saveFavorites()
            errorMessage = nil
        } catch {
            movies = previousMovies
            errorMessage = error.localizedDescription
        }
    }
}
