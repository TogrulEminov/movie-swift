import SDWebImageSwiftUI
import SwiftUI

struct MoviePosterView: View {
    let path: String?
    let size: TMDBImageSize

    var body: some View {
        WebImage(
            url: TMDBImageURL.make(
                path: path,
                size: size
            )
        ) { image in
            image
                .resizable()
                .scaledToFill()
        } placeholder: {
            placeholderView
        }
        .indicator(.activity)
        .transition(.fade(duration: 0.3))
        .aspectRatio(2 / 3, contentMode: .fit)
        .clipped()
    }

    private var placeholderView: some View {
        Image("noimage")
            .resizable()
            .scaledToFill()
            .foregroundStyle(.secondary)
    }
}
