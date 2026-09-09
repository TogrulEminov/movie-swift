import SDWebImageSwiftUI
import SwiftUI

struct MovieBackdropView: View {

    let path: String?

    var body: some View {
        WebImage(
            url: TMDBImageURL.make(
                path: path,
                size: .backdropSmall
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
        .frame(maxWidth: .infinity)
        .clipped()
    }

    private var placeholderView: some View {
        ZStack {
            Color.secondary.opacity(0.12)

            Image(systemName: "photo")
                .font(.largeTitle)
                .foregroundStyle(.secondary)
        }
    }
}
