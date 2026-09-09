import Foundation

struct CastMember: Decodable, Identifiable, Hashable {
    let id: Int
    let name: String
    let character: String
    let profilePath: String?
    let order: Int
}
