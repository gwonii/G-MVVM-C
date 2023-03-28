import struct UIKit.CGRect
import class UIKit.NSCoder
import class UIKit.UILabel
import class UIKit.UICollectionViewCell
import CommonUI

final class StoreSearchCollectionRecentlySearchCell: UICollectionViewCell, CellType {
	typealias ValueType = String
	static let reuseIdentifier: String = "StoreSearchCollectionRecentlySearchCell"
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		initView()
	}
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private let termLabel: UILabel = {
		let label: UILabel = .init()
		label.set(
			font: BaseFont.regular.font(size: 16),
			textColor: BaseColor.blue.color
		)
		label.textAlignment = .left
		return label
	}()
	
	func setup(_ value: ValueType) {
		termLabel.text = value
	}
	
	private func initView() {
		contentView.addSubview(termLabel)
		termLabel.snp.makeConstraints { make in
			make.height.equalTo(48)
			make.edges.equalToSuperview()
		}
	}
}
