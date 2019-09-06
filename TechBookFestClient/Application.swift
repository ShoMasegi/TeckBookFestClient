import UIKit
import Moya

final class Application {
    static let shared = Application()
    let rootViewController: RootViewController = RootViewController()

    private init() {}

    func setup(in window: UIWindow) {
        rootViewController.current = UINavigationController(
            rootViewController: HomeViewController.instantiateFromStoryboard()
        )
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
}

extension Application {
    func defaultNetworking() -> Networking {
        return Networking(provider: MoyaProvider(), responseFilterClosure: nil)
    }

    func stubNetworking() -> Networking {
        return Networking(
            provider: MoyaProvider(stubClosure: MoyaProvider.immediatelyStub)
        )
    }

    func debugNetworking(statusCode: Int, data: Data) -> Networking {
        return Networking(
            provider: MoyaProvider(
                endpointClosure: Networking.endpointClosure(statusCode: statusCode, data: data),
                stubClosure: MoyaProvider.immediatelyStub
            ),
            responseFilterClosure: responseFilterClosure()
        )
    }

    private func responseFilterClosure() -> ((Int) -> Bool) {
        return { statusCode -> Bool in
            switch statusCode {
            case 426:
                let lockViewController = LockViewController.instantiateFromStoryboard()
                lockViewController.type = .versionUpdate
                self.rootViewController.animateFadeTransition(to: lockViewController)
                return false
            case 503:
                let lockViewController = LockViewController.instantiateFromStoryboard()
                lockViewController.type = .maintenance
                self.rootViewController.animateFadeTransition(to: lockViewController)
                return false
            default:
                return true
            }
        }
    }
}
