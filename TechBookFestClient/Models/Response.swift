import Foundation
import Moya

struct Response<T: Decodable> {
    let data: T
}

struct ErrorResponse: Decodable {
    let message: String?
}

extension Response where T: Decodable {
    init(response: Moya.Response) throws {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        let data: T = try decoder.decode(T.self, from: response.data)
        self.init(data: data)
    }
}

extension ErrorResponse {
    init(response: Moya.Response) throws {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        let errorResponse = try decoder.decode(ErrorResponse.self, from: response.data)
        self.init(message: errorResponse.message)
    }
}