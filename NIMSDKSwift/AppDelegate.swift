import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        NIMSDKManager.shared.regist()

        window = UIWindow(frame: UIScreen.main.bounds)

        let loginViewController = LoginViewController()
        loginViewController.title = "登录"
        let navigationController = UINavigationController(rootViewController: loginViewController)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }
}
