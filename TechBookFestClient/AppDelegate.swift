import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        setupWindow()
        setupNavigationBar()
        return true
    }

    private func setupWindow() {
        window = {
            let window = UIWindow(frame: UIScreen.main.bounds)
            Application.shared.setup(in: window)
            return window
        }()
    }

    private func setupNavigationBar() {
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().barTintColor = UIColor(red: 103/255, green: 173/255, blue: 91/255, alpha: 1.0)
        UINavigationBar.appearance().barStyle = .black
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().shadowImage = UIImage()
    }
}
