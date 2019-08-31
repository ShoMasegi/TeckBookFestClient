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
        #if STUB
            return stubUseCaseProvider()
        #elseif DEBUG
            return debugUseCaseProvider(statusCode: 426, data: stubbedResponse("error"))
        #else
            return releaseUseCaseProvider()
        #endif
    }

    private func releaseUseCaseProvider() -> UseCaseProvider {
        let networking = Networking.newDefaultNetworking(
            responseFilterClosure: responseFilterClosure()
        )
        return UseCaseProvider(networking: networking)
    }

    private func stubUseCaseProvider() -> UseCaseProvider {
        let networking = Networking.newStubNetworking()
        return UseCaseProvider(networking: networking)
    }

    private func debugUseCaseProvider(statusCode: Int, data: Data) -> UseCaseProvider {
        let networking = Networking.newDebugNetworking(
            statusCode: statusCode,
            data: data,
            responseFilterClosure: responseFilterClosure()
        )
        return UseCaseProvider(networking: networking)
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
