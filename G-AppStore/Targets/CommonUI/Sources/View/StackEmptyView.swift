import class UIKit.UIView
import class UIKit.NSLayoutConstraint
import class UIKit.NSCoder

public final class StackEmptyView: UIView {
	public init(axis: NSLayoutConstraint.Axis) {
		super.init(frame: .zero)

		backgroundColor = .clear
		setContentHuggingPriority(.defaultLow, for: axis)
	}
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
