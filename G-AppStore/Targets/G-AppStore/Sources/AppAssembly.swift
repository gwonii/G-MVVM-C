import class UIKit.UINavigationController
import Swinject
import DIContainer
import CommonData

public class AppAssembly: Assembly {
	public func assemble(container: Container) {
		container.register(UINavigationController.self, name: "main") { _ in
			return UINavigationController()
		}.inObjectScope(.container)
		
		container.register(UserDefaultsStore.self) { _ in
			return DefaultUserDefaultsStore(userDefautls: .standard)
		}.inObjectScope(.container)
	}
}
