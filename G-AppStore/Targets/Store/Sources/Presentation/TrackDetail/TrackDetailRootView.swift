import class UIKit.UILabel
import class UIKit.UIScreen
import class UIKit.UIStackView
import class UIKit.UIScrollView
import class UIKit.NSCoder
import class UIKit.UIView
import class UIKit.UIScrollView
import CommonUI
import Kingfisher

final class TrackDetailRootView: BaseRootView<TrackDetailInput> {
	override init() {
		super.init()
		initView()
	}
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private let mainScrollView: UIScrollView = .init()
	private let mainContentView: UIView = .init()
	
	private let contentHeaderView: TrackDetailHeaderView = .init()
	private let attributesView: TrackDetailAttributesView = .init()
	private let screenshotsView: ScreenshotsView = .init(screenshotWidth: UIScreen.width * 0.7, cornerRadius: 32)
	
	private lazy var attributesStackView: UIStackView = {
		let stackView: UIStackView = .make(
			axis: .horizontal,
			alignment: .fill,
			spacing: 0,
			distribution: .fillEqually
		)
		return stackView
	}()
	
	private let screenshotsStackView: UIStackView = {
		let stackView: UIStackView = .make(
			axis: .horizontal,
			alignment: .fill,
			spacing: 16,
			distribution: .fill
		)
		return stackView
	}()
	
	private let descriptionLabel: UILabel = {
		let label: UILabel = .init()
		label.set(
			font: BaseFont.light.font(size: 14),
			textColor: BaseColor.white.color
		)
		label.numberOfLines = 0
		label.textAlignment = .left
		return label
	}()

	func setup(track: Track) {
		contentHeaderView.setup(track: track)
		attributesView.setup(track: track)
		screenshotsView.setup(screenshotURLs: track.screenshotUrls)
		descriptionLabel.text = track.description
	}
	
	// MARK: public methods
	func makeInput() -> Input {
		return Input.init()
	}

	// MARK: private methods
	private func initView() {
		addSubview(mainScrollView)
		mainScrollView.snp.makeConstraints { make in
			make.verticalEdges.equalToSuperview()
			make.horizontalEdges.equalToSuperview().inset(16)
		}
		mainScrollView.addSubview(mainContentView)
		mainContentView.snp.makeConstraints { make in
			make.width.equalToSuperview()
			make.edges.equalToSuperview()
		}
		
		[
			contentHeaderView,
			attributesView,
			screenshotsView,
			descriptionLabel
		].forEach({ mainContentView.addSubview($0) })
		
		contentHeaderView.snp.makeConstraints { make in
			make.top.leading.trailing.equalToSuperview()
		}
		
		attributesView.snp.makeConstraints { make in
			make.top.equalTo(contentHeaderView.snp.bottom).offset(20)
			make.horizontalEdges.equalToSuperview()
		}
		
		screenshotsView.snp.makeConstraints { make in
			make.top.equalTo(attributesView.snp.bottom).offset(20)
			make.horizontalEdges.equalToSuperview()
		}
		
		descriptionLabel.snp.makeConstraints { make in
			make.top.equalTo(screenshotsView.snp.bottom).offset(24)
			make.leading.trailing.bottom.equalToSuperview()
		}
	}
}
