import UIKit

final class Application {
    static let shared = Application()
    let rootViewController: RootViewController = RootViewController()

    private init() {}

    func setup(in window: UIWindow) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        rootViewController.current = storyboard.instantiateInitialViewController()
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }

    func defaultUseCaseProvider() {

    }
}
