import Foundation

struct Home: Decodable {
    let coverSection: CoverSection
    let descriptionSection: DescriptionSection
    let circlesSection: CirclesSection
}

struct CoverSection: Decodable {
    let imageUrl: String
}

struct DescriptionSection: Decodable {
    let title: String
    let description: String
}

struct CirclesSection: Decodable {
    let header: String
    let items: [Circle]
}
