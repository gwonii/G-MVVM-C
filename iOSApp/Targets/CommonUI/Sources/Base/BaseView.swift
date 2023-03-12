import UIKit

public protocol ViewDataType: Hashable {}

open class BaseView<ViewData: ViewDataType>: UIView {
	public typealias ViewData = ViewData

	public init() {
		super.init(frame: .zero)
	}
	public required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	open func setup(_ viewData: ViewData) {
		fatalError("should override method")
	}
}

open class BaseControlView<ViewData: ViewDataType>: UIControl {
	public typealias ViewData = ViewData

	public init() {
		super.init(frame: .zero)
	}
	public required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	open func setup(_ viewData: ViewData) {
		fatalError("should override method")
	}
}
