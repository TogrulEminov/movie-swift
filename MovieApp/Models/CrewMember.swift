import Foundation

struct CrewMember: Decodable, Identifiable, Hashable {
    let id: Int
    let name: String
    let job: String
    let department: String
}
