import UIKit

open class BaseRootView<Input: BaseInput>: UIView {
	public typealias Input = Input

	public init() {
		super.init(frame: .zero)
	}
	public required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
