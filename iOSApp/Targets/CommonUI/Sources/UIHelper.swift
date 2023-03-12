import UIKit

public struct UIHelper {
	public static var screenWidth: CGFloat {
		return UIScreen.main.bounds.width
	}

	public static var screenHeight: CGFloat {
		return UIScreen.main.bounds.height
	}
	
	// TODO: 나중에 필요 없는 항목은 제거할 것
	public static var safeAreaWidth: CGFloat? {
		return self.safeAreaFrame?.width
	}

	public static var safeAreaHeight: CGFloat? {
		return self.safeAreaFrame?.height
	}

	public static var safeAreaTopInset: CGFloat {
		return self.safeAreaInsets?.top ?? 0
	}

	public static var safeAreaLeftInset: CGFloat {
		return self.safeAreaInsets?.left ?? 0
	}

	public static var safeAreaRightInset: CGFloat {
		return self.safeAreaInsets?.right ?? 0
	}

	public static var safeAreaBottomInset: CGFloat {
		return self.safeAreaInsets?.bottom ?? 0
	}
	
	static var safeAreaInsets: UIEdgeInsets? {
		return UIApplication.shared.windows.first?.safeAreaInsets
	}
	
	static var safeAreaFrame: CGRect? {
		return UIApplication.shared.windows.first?.safeAreaLayoutGuide.layoutFrame
	}
}
