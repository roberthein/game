import UIKit

var App: AppDelegate {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        fatalError("AppDelegate is not loaded correctly.")
    }
    
    return appDelegate
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var game = Game.empty
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        game = Game.load() ?? Game.empty
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: MenuViewController(type: .title))
        window?.makeKeyAndVisible()
        
        return true
    }
}
