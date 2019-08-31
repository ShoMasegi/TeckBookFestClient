import Foundation
import Moya

extension Moya.Response {
    func filterAPIError() -> Result<Moya.Response, Error> {
        switch statusCode {
        case 200...299:
            return .success(self)
        default:
            do {
                let errorResponse = try ErrorResponse(response: self)
                let error = APIError.server(statusCode: statusCode, message: errorResponse.message)
                return .failure(error)
            } catch let error {
                return .failure(error)
            }
        }
    }
}
