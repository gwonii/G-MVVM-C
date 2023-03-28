import class UIKit.UIViewController

public final class ViewContainer {
	public init(
		viewController: UIViewController,
		coordinator: Coordinator
	) {
		self.viewController = viewController
		self.coordinator = coordinator
	}

	public let viewController: UIViewController
	public let coordinator: Coordinator
}
