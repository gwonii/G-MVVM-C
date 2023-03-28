import class UIKit.UILabel
import class UIKit.UIFont
import class UIKit.UIColor

public extension UILabel {
	func set(text: String = "", font: UIFont, textColor: UIColor) {
		self.text = text
		self.font = font
		self.textColor = textColor
	}
}
