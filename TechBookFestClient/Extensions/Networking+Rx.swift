import Moya
import RxMoya
import RxSwift

extension Networking {
    func request<T: Decodable>(_ target: Target) -> Observable<T> {
        return provider.rx.request(target)
            .asObservable()
            .filter { response -> Bool in
                self.responseFilterClosure?(response.statusCode) ?? true
            }
            .flatMap { response -> Observable<T> in
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .iso8601

                switch response.statusCode {
                case 200...299:
                    do {
                        let data: T = try decoder.decode(T.self, from: response.data)
                        return Observable.just(data)
                    } catch let error {
                        return Observable.error(error)
                    }

                default:
                    do {
                        let errorResponse = try decoder.decode(ErrorResponse.self, from: response.data)
                        let error = APIError.server(statusCode: response.statusCode,
                                                    message: errorResponse.message)
                        return Observable.error(error)
                    } catch let error {
                        return Observable.error(error)
                    }
                }
            }
    }
}
