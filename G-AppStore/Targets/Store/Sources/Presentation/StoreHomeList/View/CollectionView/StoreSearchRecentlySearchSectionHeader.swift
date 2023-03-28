import struct UIKit.CGRect
import class UIKit.NSCoder
import class UIKit.UICollectionReusableView
import class UIKit.UICollectionView
import class UIKit.UILabel
import CommonUI

final class StoreSearchRecentlySearchSectionHeader: UICollectionReusableView {
	static let reuseIdentifer: String = "StoreSearchRecentlySearchSectionHeader"
	override init(frame: CGRect) {
		super.init(frame: frame)
		initView()
	}
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private let titleLabel: UILabel = {
		let label: UILabel = .init()
		label.set(
			text: "최근 검색어",
			font: BaseFont.semiBold.font(size: 16),
			textColor: BaseColor.white.color
		)
		label.textAlignment = .left
		return label
	}()

	private func initView() {
		addSubview(titleLabel)
		titleLabel.snp.makeConstraints { make in
			make.horizontalEdges.equalToSuperview().inset(16)
			make.centerY.equalToSuperview()
		}
	}
}
