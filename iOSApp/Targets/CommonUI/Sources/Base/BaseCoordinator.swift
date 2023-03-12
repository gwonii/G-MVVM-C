import UIKit

public protocol CoordinatorType {
	var childCoordinators: [CoordinatorType] { get }
	var navigationController: UINavigationController { get }
	var topViewController: UIViewController? { get }
	func start()
}

open class BaseCoordinator: NSObject, CoordinatorType {
	public var childCoordinators: [CoordinatorType] = []
	public let navigationController: UINavigationController
	public var topViewController: UIViewController?

	public init(_ navigaitonController: UINavigationController) {
		self.navigationController = navigaitonController
	}

	open func start() {
		fatalError("should override method")
	}
}
