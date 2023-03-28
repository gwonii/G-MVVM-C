import struct UIKit.CGRect
import struct UIKit.AttributedString
import struct UIKit.URL
import class UIKit.NSCoder
import class UIKit.UICollectionViewCell
import class UIKit.UIStackView
import class UIKit.UIImageView
import class UIKit.UILabel
import class UIKit.UIScreen
import class UIKit.UIButton
import CommonUI
import Kingfisher
import Cosmos

final class StoreSearchCollectionTrackCell: UICollectionViewCell, CellType {
	typealias ValueType = Track
	static let reuseIdentifier: String = "StoreSearchCollectionTrackCell"
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		initView()
	}
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private let screenshotsView: ScreenshotsView = .init(screenshotWidth: (UIScreen.width - 16) * 0.3, cornerRadius: 16)
	
	private lazy var headerStackView: UIStackView = {
		let stackView: UIStackView = .make(
			arrangedSubviews: [
				trackIconImageView,
				headerTextStackView,
				downloadButton
			],
			axis: .horizontal,
			alignment: .center,
			spacing: 16,
			distribution: .fill
		)
		stackView.snp.makeConstraints { make in
			make.height.equalTo(80)
		}
		return stackView
	}()
	
	private let trackIconImageView: UIImageView = {
		let imageView: UIImageView = .init()
		imageView.roundCorners(16)
		imageView.snp.makeConstraints { make in
			make.size.equalTo(56)
		}
		return imageView
	}()
	
	private lazy var headerTextStackView: UIStackView = {
		let stackView: UIStackView = .make(
			arrangedSubviews: [
				trackNameLabel,
				trackDescriptionLabel,
				ratingView
			],
			axis: .vertical,
			alignment: .leading,
			spacing: 4,
			distribution: .fill
		)
		return stackView
	}()
	
	private let trackNameLabel: UILabel = {
		let label: UILabel = .init()
		label.set(
			font: BaseFont.medium.font(size: 16),
			textColor: BaseColor.white.color
		)
		return label
	}()
	
	private let trackDescriptionLabel: UILabel = {
		let label: UILabel = .init()
		label.set(
			font: BaseFont.light.font(size: 14),
			textColor: BaseColor.white.color
		)
		return label
	}()
	
	private let ratingView: CosmosView = {
		let view: CosmosView = .init()
		view.settings.starSize = 12
		view.settings.starMargin = 1
		view.settings.filledColor = BaseColor.gray.color
		view.settings.emptyColor = BaseColor.black.color
		view.settings.emptyBorderColor = BaseColor.gray.color
		view.settings.emptyBorderWidth = 1
		view.settings.filledBorderWidth = 0
		view.settings.disablePanGestures = false
		view.rating = 2
		return view
	}()
	
	private let downloadButton: UIButton = {
		var config: UIButton.Configuration = .filled()
		var attributedTitle: AttributedString = .init("받기")
		attributedTitle.font = BaseFont.medium.font(size: 16)
		config.attributedTitle = attributedTitle
		config.cornerStyle = .capsule
		let button: UIButton = .init(configuration: config)
		button.snp.makeConstraints { make in
			make.width.equalTo(56)
			make.height.equalTo(26)
		}
		button.isUserInteractionEnabled = false
		return button
	}()
	
	func setup(_ value: ValueType) {
		if let url = URL(string: value.artworkURL60) {
			trackIconImageView.kf.setImage(
				with: url,
				placeholder: CommonUIAsset.Images.noImage.image,
				options: [.transition(.fade(1.0))]
			)
		}
		trackNameLabel.text = value.trackName
		trackDescriptionLabel.text = value.description
		ratingView.rating = value.averageUserRating
		ratingView.text = value.userRatingCount.formatNumber()
		
		screenshotsView.setup(screenshotURLs: value.screenshotUrls)
	}
	
	private func initView() {
		contentView.addSubview(headerStackView)
		headerStackView.snp.makeConstraints { make in
			make.top.leading.trailing.equalToSuperview()
		}
		contentView.addSubview(screenshotsView)
		screenshotsView.snp.makeConstraints { make in
			make.top.equalTo(headerStackView.snp.bottom).offset(8)
			make.horizontalEdges.equalToSuperview()
		}
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		
		trackIconImageView.image = nil
		trackNameLabel.text = nil
		trackDescriptionLabel.text = nil
		ratingView.rating = 0.0
		ratingView.text = nil
		screenshotsView.clear()
	}
}
