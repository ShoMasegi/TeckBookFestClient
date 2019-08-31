import Moya
import RxMoya
import RxSwift


protocol NetworkingType {
    associatedtype API: TargetType
    var provider: MoyaProvider<API> { get }
}

struct Networking: NetworkingType {
    typealias API = TBAPI
    let provider: MoyaProvider<API>
    let responseFilterClosure: ((Int) -> Bool)?

    init(provider: MoyaProvider<API>, responseFilterClosure: ((Int) -> Bool)? = nil) {
        self.provider = provider
        self.responseFilterClosure = responseFilterClosure
    }
}

extension Networking {
    func request<T: Decodable>(_ target: API, completion: @escaping (Result<T, Error>) -> Void) {
        provider.request(target) { result in
            switch result {
            case .success(let response):
                guard self.responseFilterClosure?(response.statusCode) ?? true else { return }
                let filteredResult = response.filterAPIError()
                switch filteredResult {
                case .success(let response):
                    do {
                        let response = try Response<T>(response: response)
                        completion(.success(response.data))
                    } catch let error {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            case .failure(let error):
                print("Networking request error: \(error)")
                completion(.failure(error))
            }
        }
    }

    func request<T: Decodable>(_ target: API) -> Observable<T> {
        return provider.rx.request(target)
            .asObservable()
            .filter { response -> Bool in
                self.responseFilterClosure?(response.statusCode) ?? true
            }
            .flatMap { response -> Observable<T> in
                let filteredResult = response.filterAPIError()
                switch filteredResult {
                case .success(let response):
                    do {
                        let response = try Response<T>(response: response)
                        return Observable.just(response.data)
                    } catch let error {
                        return Observable<T>.error(error)
                    }
                case .failure(let error):
                    return Observable.error(error)
                }
            }
    }
}

extension NetworkingType {
    static func newDefaultNetworking(responseFilterClosure: ((Int) -> Bool)? = nil) -> Networking {
        return Networking(
            provider: MoyaProvider(
                requestClosure: requestClosure()
            ),
            responseFilterClosure: responseFilterClosure
        )
    }

    static func requestClosure() -> MoyaProvider<API>.RequestClosure {
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

extension NetworkingType {
    static func newStubNetworking() -> Networking {
        return Networking(
            provider: MoyaProvider(
                requestClosure: Networking.requestClosure(),
                stubClosure: MoyaProvider.immediatelyStub
            )
        )
    }

    static func newTestNetworking(statusCode: Int, data: Data) -> Networking {
        return Networking(
            provider: MoyaProvider(
                endpointClosure: Networking.endpointClosure(statusCode: statusCode, data: data),
                stubClosure: MoyaProvider.immediatelyStub
            )
        )
    }

    static func endpointClosure(statusCode: Int, data: Data) -> MoyaProvider<API>.EndpointClosure {
        return { target in
            let url = target.baseURL.appendingPathComponent(target.path).absoluteString
            let sampleResponse: Endpoint.SampleResponseClosure = {
                .networkResponse(statusCode, data)
            }
            return Endpoint(url: url, sampleResponseClosure: sampleResponse, method: target.method, task: target.task, httpHeaderFields: target.headers)
        }
    }
}
