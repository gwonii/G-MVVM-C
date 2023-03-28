import class UIKit.NSObject
import class UIKit.UINavigationController
import class UIKit.UIViewController

public protocol Coordinator {
	var childCoordinators: [Coordinator] { get }
	var type: CoordinatorType { get }
}

open class BaseCoordinator: NSObject, Coordinator {
	public var childCoordinators: [Coordinator] = []
	public let navigationController: UINavigationController
	public var topViewController: UIViewController?
	public let type: CoordinatorType

	public init(_ navigaitonController: UINavigationController, type: CoordinatorType) {
		self.navigationController = navigaitonController
		self.type = type
	}

	open func start() {
		fatalError("should override method")
	}
	
	open func push(_ viewController: UIViewController) {
		navigationController.pushViewController(viewController, animated: true)
	}
	
	open func pop() {
		childCoordinators.removeAll(where: { [weak self] in
			return $0.type == self?.type
		})
		navigationController.popViewController(animated: true)
	}
}
