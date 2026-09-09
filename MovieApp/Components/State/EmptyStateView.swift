import SwiftUI

struct EmptyStateView: View {
    var title: String = "No Movies found"
    var message: String = "There are currently no movies to display"
    var body: some View {
        ContentUnavailableView(
            title,
            systemImage: "film.stack",
            description: Text(message)
        )
    }
}
