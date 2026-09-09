import SwiftUI

struct GenreChipView: View {
    let genre: Genre
    var body: some View {
        Text(genre.name).font(.caption).fontWeight(.semibold).foregroundStyle(
            .primary
        ).padding(.horizontal, 12).padding(.vertical, 7).background(
            .thinMaterial
        ).clipShape(Capsule()).overlay {
            Capsule().stroke(Color.secondary.opacity(0.2), lineWidth: 1)
        }
    }
}
