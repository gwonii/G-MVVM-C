import struct UIKit.CGRect
import struct UIKit.CGFloat
import class UIKit.UIScreen

public extension UIScreen {
	static var size: CGRect {
		return self.main.bounds
	}
	
	static var width: CGFloat {
		return self.main.bounds.width
	}
	
	static var height: CGFloat {
		return self.main.bounds.height
	}
}
