import Foundation
import UIKit

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
    case sponsor
    case normal

    var color: UIColor {
        switch self {
        case .operator: return UIColor(red: 103/255, green: 173/255, blue: 91/255, alpha: 1.0)
        case .sponsor: return UIColor(red: 252/255, green: 235/255, blue: 136/255, alpha: 1.0)
        case .normal: return UIColor(red: 204/255, green: 242/255, blue: 253/255, alpha: 1.0)
        }
    }
}
