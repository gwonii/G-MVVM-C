import struct UIKit.CGFloat
import class UIKit.UIStackView
import class UIKit.UIView
import class UIKit.NSLayoutConstraint

public extension UIStackView {
	static func make(
		arrangedSubviews: [UIView] = [],
		axis: NSLayoutConstraint.Axis,
		alignment: Alignment,
		spacing: CGFloat,
		distribution: Distribution
	) -> UIStackView {
		let stackView: UIStackView = .init()
		stackView.axis = axis
		stackView.alignment = alignment
		stackView.spacing = spacing
		stackView.distribution = distribution
		stackView.addArrangeSubviews(arrangedSubviews)
		return stackView
	}

	func addArrangeSubviews(_ views: [UIView]) {
		for view in views {
			self.addArrangedSubview(view)
		}
	}
}
