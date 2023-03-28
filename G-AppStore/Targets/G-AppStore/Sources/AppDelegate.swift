import protocol UIKit.UIApplicationDelegate
import class UIKit.UIResponder
import class UIKit.UIWindow
import class UIKit.UIApplication
import class UIKit.UIScreen
import class UIKit.UINavigationController
import DIContainer
import CommonUI
import CommonData
import Store

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
		
		applyAssemblies([
			AppAssembly(),
			StoreAssembly(),
			CommonDataAssembly()
		])
		let navigationController: UINavigationController = get("main")
		let coordinator: AppCoordinator = .init(navigationController, type: .app)
		coordinator.start()
		
		window = UIWindow(frame: UIScreen.size)
		window?.rootViewController = navigationController
		window?.makeKeyAndVisible()
        return true
    }
}
