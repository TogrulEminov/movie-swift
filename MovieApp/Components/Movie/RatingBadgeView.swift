import SwiftUI

struct RatingBadgeView: View {
    let rating: Double
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "star.fill").foregroundStyle(.yellow)
            Text(rating, format: .number.precision(.fractionLength(1)))
                .fontWeight(.semibold)
        }
        .font(.caption)
        .foregroundStyle(.primary)
        .padding(.horizontal, 8)
        .padding(.vertical, 5)
        .background(.ultraThinMaterial).clipShape(Capsule())
    }
}
