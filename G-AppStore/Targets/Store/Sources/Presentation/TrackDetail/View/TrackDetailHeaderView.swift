import struct UIKit.URL
import struct UIKit.AttributedString
import class UIKit.UIImage
import class UIKit.UIView
import class UIKit.NSCoder
import class UIKit.UIImageView
import class UIKit.UILabel
import class UIKit.UIStackView
import class UIKit.UIButton
import CommonUI

final class TrackDetailHeaderView: UIView {
	init() {
		super.init(frame: .zero)
		
		initView()
	}
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private let trackIconImageView: UIImageView = {
		let imageView: UIImageView = .init()
		imageView.image = CommonUIAsset.Images.noImage.image
		imageView.snp.makeConstraints { make in
			make.size.equalTo(100)
		}
		imageView.roundCorners(16)
		return imageView
	}()
	
	private let trackTitleLabel: UILabel = {
		let label: UILabel = .init()
		label.set(
			font: BaseFont.extraBold.font(size: 20),
			textColor: BaseColor.white.color
		)
		label.textAlignment = .left
		label.numberOfLines = 2
		return label
	}()
	
	private let trackSubtitle: UILabel = {
		let label: UILabel = .init()
		label.set(
			font: BaseFont.medium.font(size: 16),
			textColor: BaseColor.white.color
		)
		label.textAlignment = .left
		label.numberOfLines = 2
		return label
	}()
	
	private lazy var buttonsStackView: UIStackView = {
		let stackView: UIStackView = .make(
			arrangedSubviews: [
				downloadButton,
				StackEmptyView(axis: .horizontal),
				moreButton
			],
			axis: .horizontal,
			alignment: .fill,
			spacing: 8,
			distribution: .fill
		)
		return stackView
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
		return button
	}()
	
	private let moreButton: UIButton = {
		var config: UIButton.Configuration = .filled()
		config.image = UIImage(systemName: "ellipsis")
		config.imagePadding = 2
		config.contentInsets = .init(top: 2, leading: 2, bottom: 2, trailing: 2)
		config.cornerStyle = .capsule
		let button: UIButton = .init(configuration: config)
		return button
	}()

	func setup(track: Track) {
		if let url = URL(string: track.artworkURL100) {
			trackIconImageView.kf.setImage(
				with: url,
				placeholder: BaseImage.noImage.image,
				options: [.transition(.fade(1.0))]
			)
		}
		trackTitleLabel.text = track.trackName
		if let subtitle: String = track.description.components(separatedBy: "\\").first {
			trackSubtitle.text = subtitle
		}
	}
	
	private func initView() {
		[
			trackIconImageView,
			trackTitleLabel,
			trackSubtitle,
			buttonsStackView
		].forEach({ addSubview($0) })
		
		trackIconImageView.snp.makeConstraints { make in
			make.top.leading.equalToSuperview()
		}
		trackTitleLabel.snp.makeConstraints { make in
			make.top.trailing.equalToSuperview()
			make.leading.equalTo(trackIconImageView.snp.trailing).offset(12)
		}
		trackSubtitle.snp.makeConstraints { make in
			make.top.equalTo(trackTitleLabel.snp.bottom).offset(2)
			make.leading.equalTo(trackTitleLabel.snp.leading)
			make.trailing.equalTo(trackTitleLabel.snp.trailing)
		}
		buttonsStackView.snp.makeConstraints { make in
			make.top.equalTo(trackSubtitle.snp.bottom).offset(2)
			make.leading.equalTo(trackSubtitle.snp.leading)
			make.trailing.equalToSuperview()
			make.bottom.equalToSuperview()
		}
	}
}
