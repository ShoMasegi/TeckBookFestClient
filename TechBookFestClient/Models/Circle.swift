import Foundation

struct Circle: Decodable {
    let id: Int
    let title: String
    let circleType: CircleType
    let position: String
    let category: String
    let description: String
    let imageUrl: String
}

enum CircleType: String, Decodable {
    case `operator`
}
