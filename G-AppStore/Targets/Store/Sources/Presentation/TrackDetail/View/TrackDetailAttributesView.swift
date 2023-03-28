import class UIKit.UIView
import class UIKit.NSCoder
import class UIKit.UIStackView

final class TrackDetailAttributesView: UIView {
	init() {
		super.init(frame: .zero)
		
		initView()
	}
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	private lazy var mainStackView: UIStackView = {
		let stackView: UIStackView = .make(
			axis: .horizontal,
			alignment: .fill,
			spacing: 0,
			distribution: .fillEqually
		)
		return stackView
	}()
	
	func setup(track: Track) {
		let attributeItems: [TrackDetailAttributeItem] = [
			.init(category: "평가 개수", content: "\(track.userRatingCount.formatNumber())"),
			.init(category: "연령", content: track.trackContentRating),
			.init(category: "개발자", content: track.artistName),
			.init(category: "장르", content: track.genres.first ?? "공통")
		]
	
		let itemViews: [TrackDetailAttributeItemView] = attributeItems.map({
			let view: TrackDetailAttributeItemView = .init()
			view.setup(category: $0.category, content: $0.content)
			return view
		})
		mainStackView.addArrangeSubviews(itemViews)
	}
	
	private func initView() {
		addSubview(mainStackView)
		mainStackView.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}
	}
}
