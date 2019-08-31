import Foundation

enum APIError: Error {
    case server(statusCode: Int, message: String?)
    case other(message: String?)

    var message: String {
        switch self {
        case .server(let statusCode, let message):
            if let message = message {
                return message
            } else {
                return "status code: \(statusCode)"
            }
        case .other(let message):
            return message ?? ""
        }
    }
}
