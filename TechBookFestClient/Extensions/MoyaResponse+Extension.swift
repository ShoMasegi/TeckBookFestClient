import Foundation
import Moya

extension Moya.Response {
    func decode<T: Decodable>() -> T  {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            fatalError("failed to decode.")
        }
    }
}
