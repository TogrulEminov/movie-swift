import Foundation

struct CreditsResponse: Decodable {
    let id: Int
    let cast: [CastMember]
    let crew: [CrewMember]
}
