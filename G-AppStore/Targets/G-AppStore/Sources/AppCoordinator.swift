import class UIKit.UINavigationController
import CommonUI
import DIContainer
import Store

final class AppCoordinator: BaseCoordinator {
	override init(_ navigaitonController: UINavigationController, type: CoordinatorType) {
		super.init(navigaitonController, type: .app)
	}
	
	override func start() {
		let viewContainer: ViewContainer = get(CoordinatorType.storeHomeList.rawValue)
		childCoordinators.append(viewContainer.coordinator)
		navigationController.pushViewController(viewContainer.viewController, animated: true)
	}
}
