import Foundation

final class UseCaseProvider {
    private let networking: Networking

    init(networking: Networking = Networking.newDefaultNetworking()) {
        self.networking = networking
    }
}
