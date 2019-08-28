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

    func defaultUseCaseProvider() {

    }
}
