import SwiftUI

struct CastCardView: View {
    let member: CastMember
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            MoviePosterView(path: member.profilePath, size: .profile).frame(
                width: 105,
                height: 135
            ).clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

            Text(member.name).font(.subheadline).fontWeight(.semibold)
                .lineLimit(1)
            Text(member.character).font(.caption).foregroundStyle(.secondary)
                .lineLimit(1)
        }.frame(width: 105, alignment: .leading).accessibilityElement(
            children: .combine
        ).accessibilityLabel("\(member.name),playing \(member.character)")
    }
}
