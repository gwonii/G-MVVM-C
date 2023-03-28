import Foundation

public extension Int {
	func formatNumber() -> String {
		let formatter = NumberFormatter()
		formatter.numberStyle = .decimal
		formatter.locale = Locale(identifier: "ko_KR")
		formatter.maximumFractionDigits = 1

		if self >= 100000000 {
			let billion = Double(self) / 100000000.0
			guard let value = formatter.string(from: NSNumber(value: billion)) else {
				return ""
			}
			return "\(value) 억"
		} else if self >= 10000 {
			let tenThousand = Double(self) / 10000.0
			guard let value = formatter.string(from: NSNumber(value: tenThousand)) else {
				return ""
			}
			return "\(value) 만"
		} else if self >= 1000 {
			let thousand = Double(self) / 1000.0
			guard let value = formatter.string(from: NSNumber(value: thousand)) else {
				return ""
			}
			return "\(value) 천"
		} else {
			return "\(self)"
		}
	}
}
