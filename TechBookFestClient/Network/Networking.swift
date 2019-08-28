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
    func request(_ target: API, completion: @escaping (Moya.Response) -> Void) {
        provider.request(target) { result in
            switch result {
            case .success(let response):
                if self.responseFilterClosure?(response.statusCode) ?? true {
                    completion(response)
                }
            case .failure(let error):
                print("Networking request error: \(error)")
            }
        }
    }

    func request(_ target: API) -> Observable<Moya.Response> {
        return provider.rx.request(target)
            .asObservable()
            .filter { response -> Bool in
                self.responseFilterClosure?(response.statusCode) ?? true
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