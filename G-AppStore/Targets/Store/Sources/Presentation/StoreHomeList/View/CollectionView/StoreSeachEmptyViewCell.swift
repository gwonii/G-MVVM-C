import struct UIKit.CGRect
import class UIKit.UICollectionViewCell
import class UIKit.NSCoder
import class UIKit.UILabel
import CommonUI

final class StoreSearchEmptyViewCell: UICollectionViewCell, CellType {
	typealias ValueType = String
	
	static let reuseIdentifier: String = "StoreSearchEmptyViewCell"

	override init(frame: CGRect) {
		super.init(frame: frame)
		initView()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private let messageLabel: UILabel = {
		let label: UILabel = .init()
		label.set(
			font: BaseFont.regular.font(size: 16),
			textColor: BaseColor.gray.color
		)
		return label
	}()

	func setup(_ value: ValueType) {
		messageLabel.text = value
	}

	private func initView() {
		contentView.snp.makeConstraints { make in
			make.leading.trailing.bottom.equalToSuperview()
		}
		contentView.addSubview(messageLabel)
		messageLabel.snp.makeConstraints { make in
			make.center.equalToSuperview()
		}
	}
}
