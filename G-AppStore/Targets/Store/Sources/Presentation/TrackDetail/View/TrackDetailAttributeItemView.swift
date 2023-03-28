import class UIKit.UILabel
import class UIKit.UIStackView
import class UIKit.NSCoder
import class UIKit.UIView
import CommonUI

struct TrackDetailAttributeItem {
	let category: String
	let content: String
}

final class TrackDetailAttributeItemView: UIView {
	init() {
		super.init(frame: .zero)
		
		initView()
	}
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private let mainStackView: UIStackView = {
		let stackView: UIStackView = .make(
			axis: .vertical,
			alignment: .center,
			spacing: 4,
			distribution: .fill
		)
		return stackView
	}()
	
	private let categoryLabel: UILabel = {
		let label: UILabel = .init()
		label.set(
			font: BaseFont.medium.font(size: 14),
			textColor: BaseColor.gray.color
		)
		label.textAlignment = .center
		return label
	}()
	
	private let contentLabel: UILabel = {
		let label: UILabel = .init()
		label.set(
			font: BaseFont.bold.font(size: 14),
			textColor: BaseColor.white.color
		)
		label.numberOfLines = 2
		label.textAlignment = .center
		return label
	}()
	
	func setup(category: String, content: String) {
		mainStackView.addArrangeSubviews([
			categoryLabel,
			StackEmptyView(axis: .vertical),
			contentLabel
		])
		categoryLabel.text = category
		contentLabel.text = content
	}
	
	private func initView() {
		addSubview(mainStackView)
		mainStackView.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}
	}
}
