import Foundation

struct Circle: Decodable {
    let title: String
    let circleType: CircleType
    let category: String
    let imageUrl: String
}

enum CircleType: String, Decodable {
    case `operator`
}
