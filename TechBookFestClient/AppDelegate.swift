import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        setupWindow()
        return true
    }

    private func setupWindow() {
        window = {
            let window = UIWindow(frame: UIScreen.main.bounds)
            Application.shared.setup(in: window)
            return window
        }()
    }
}
