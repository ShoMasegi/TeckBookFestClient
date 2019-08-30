import Foundation

final class HomeUseCase {
    private let network: Networking
    init(network: Networking) {
        self.network = network
    }

    func getHome(completion: @escaping (Result<Home, Error>) -> Void) {
        network.request(.home, completion: completion)
    }
}
