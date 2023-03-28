import class UIKit.UICollectionViewCell

public protocol CellType {
	associatedtype ValueType
	static var reuseIdentifier: String { get }
	
	func setup(_ value: ValueType)
}
