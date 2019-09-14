import Moya
import RxMoya
import RxSwift

struct Networking {
    typealias Target = TBAPI
    let provider: MoyaProvider<Target>
    let responseFilterClosure: ((Int) -> Bool)?

    init(provider: MoyaProvider<Target>, responseFilterClosure: ((Int) -> Bool)? = nil) {
        self.provider = provider
        self.responseFilterClosure = responseFilterClosure
    }
}

extension Networking {
    func request<T: Decodable>(_ target: Target, completion: @escaping (Result<T, Error>) -> Void) {
        provider.request(target) { result in
            switch result {
            case .success(let response):

                guard self.responseFilterClosure?(response.statusCode) ?? true else {
                    return
                }

                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .iso8601

                switch response.statusCode {
                case 200...299:
                    do {
                        let data: T = try decoder.decode(T.self, from: response.data)
                        completion(.success(data))
                    } catch let error {
                        completion(.failure(error))
                    }

                default:
                    do {
                        let errorResponse = try decoder.decode(ErrorResponse.self, from: response.data)
                        let error = APIError.server(statusCode: response.statusCode,
                                                    message: errorResponse.message)
                        return completion(.failure(error))
                    } catch let error {
                        return completion(.failure(error))
                    }
                }

            case .failure(let error):
                print("Networking request error: \(error)")
                completion(.failure(error))
            }
        }
    }
}

extension Networking {
    static func newDefaultNetworking(responseFilterClosure: ((Int) -> Bool)? = nil) -> Networking {
        return Networking(
            provider: MoyaProvider(requestClosure: requestClosure()),
            responseFilterClosure: responseFilterClosure
        )
    }

    static func requestClosure() -> MoyaProvider<Target>.RequestClosure {
        return { endpoint, closure in
            do {
                var request = try endpoint.urlRequest()
                request.httpShouldHandleCookies = false
                closure(.success(request))
            } catch let error {
                closure(.failure(MoyaError.underlying(error, nil)))
            }
        }
    }
}

// MARK: Test

extension Networking {
    static func endpointClosure(statusCode: Int, data: Data) -> MoyaProvider<Target>.EndpointClosure {
        return { target in
            let url = target.baseURL.appendingPathComponent(target.path).absoluteString
            let sampleResponse: Endpoint.SampleResponseClosure = {
                .networkResponse(statusCode, data)
            }
            return Endpoint(url: url, sampleResponseClosure: sampleResponse, method: target.method, task: target.task, httpHeaderFields: target.headers)
        }
    }
}
