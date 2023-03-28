import struct UIKit.IndexPath
import class UIKit.UICollectionView
import Combine
import CombineCocoa

public extension UICollectionView {
	var didSelectItem: AnyPublisher<IndexPath, Never> {
		return self.didSelectItemPublisher
	}
}
