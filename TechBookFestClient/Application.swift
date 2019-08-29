import UIKit

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

    func defaultUseCaseProvider() -> UseCaseProvider {
        let networking = Networking.newDefaultNetworking(responseFilterClosure: { statusCode -> Bool in
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
        })
        return UseCaseProvider(networking: networking)
    }
}
