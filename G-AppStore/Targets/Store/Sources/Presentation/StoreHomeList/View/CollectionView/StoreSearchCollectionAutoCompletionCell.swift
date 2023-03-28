import struct UIKit.CGRect
import class UIKit.UICollectionViewCell
import class UIKit.NSCoder
import class UIKit.UIStackView
import class UIKit.UIImageView
import class UIKit.UILabel
import CommonUI

final class StoreSearchCollectionAutoCompletionCell: UICollectionViewCell, CellType {
	typealias ValueType = String
	static let reuseIdentifier: String = "StoreSearchCollectionAutoCompletionCell"
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		initView()
	}
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private lazy var mainStackView: UIStackView = {
		let stackView: UIStackView = .make(
			arrangedSubviews: [
				searchIconImageView,
				termLabel
			],
			axis: .horizontal,
			alignment: .center,
			spacing: 8,
			distribution: .fill
		)
		return stackView
	}()
	
	private let searchIconImageView: UIImageView = {
		let imageView: UIImageView = .init(image: .init(systemName: "magnifyingglass"))
		imageView.contentMode = .scaleAspectFit
		imageView.tintColor = BaseColor.white.color
		imageView.snp.makeConstraints { make in
			make.size.equalTo(24)
		}
		return imageView
	}()
	
	private let termLabel: UILabel = {
		let label: UILabel = .init()
		label.set(
			font: BaseFont.regular.font(size: 16),
			textColor: BaseColor.white.color
		)
		label.textAlignment = .left
		label.setContentHuggingPriority(.defaultLow, for: .horizontal)
		return label
	}()
	
	func setup(_ value: ValueType) {
		termLabel.text = value
	}
	
	private func initView() {
		contentView.addSubview(mainStackView)
		mainStackView.snp.makeConstraints { make in
			make.height.equalTo(48)
			make.edges.equalToSuperview()
		}
	}
}
