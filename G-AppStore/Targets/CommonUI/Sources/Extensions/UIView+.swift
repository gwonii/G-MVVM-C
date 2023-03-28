import struct UIKit.CGFloat
import struct UIKit.CACornerMask
import class UIKit.UIView
import class UIKit.UIColor

public extension UIView {
	func roundCorners(
	  _ radius: CGFloat,
	  corners: CACornerMask = [
		.layerMinXMinYCorner,
		.layerMinXMaxYCorner,
		.layerMaxXMinYCorner,
		.layerMaxXMaxYCorner
	  ]
	) {
		layer.cornerCurve = .continuous
		layer.cornerRadius = radius
		layer.maskedCorners = corners
		clipsToBounds = true
	}
}

public extension UIView {
	func setBorder(width: CGFloat, color: UIColor) {
		layer.borderWidth = width
		layer.borderColor = color.cgColor
	}
}
