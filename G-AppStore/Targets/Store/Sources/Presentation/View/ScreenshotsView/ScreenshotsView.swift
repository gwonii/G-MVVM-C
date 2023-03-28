import struct UIKit.URL
import struct UIKit.CGFloat
import class UIKit.NSCoder
import class UIKit.UIScrollView
import class UIKit.UIStackView
import class UIKit.UIView
import class UIKit.UIImageView
import CommonUI

final class ScreenshotsView: UIView {
	static let sizeRatio: CGFloat = 1.76
	
	init(screenshotWidth: CGFloat, cornerRadius: CGFloat) {
		self.screenshotWidth = screenshotWidth
		self.cornerRadius = cornerRadius
		super.init(frame: .zero)
		
		initView()
	}
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private let screenshotWidth: CGFloat
	private let cornerRadius: CGFloat
	
	private let mainScrollView: UIScrollView = {
		let scrollView: UIScrollView = .init()
		scrollView.showsHorizontalScrollIndicator = false
		scrollView.isPagingEnabled = true
		return scrollView
	}()
	
	private let mainStackView: UIStackView = {
		let stackView: UIStackView = .make(
			axis: .horizontal,
			alignment: .fill,
			spacing: 8,
			distribution: .fill
		)
		return stackView
	}()
	
	func setup(screenshotURLs: [String]) {
		let imageViews: [UIImageView] = screenshotURLs.map({ (urlString) in
			let imageView: UIImageView = .init()
			imageView.contentMode = .scaleAspectFit
			imageView.roundCorners(cornerRadius)
			imageView.snp.makeConstraints { make in
				make.width.equalTo(screenshotWidth)
				make.height.equalTo(screenshotWidth * Self.sizeRatio)
			}
			if let url = URL(string: urlString) {
				imageView.kf.setImage(
					with: url,
					options: [.transition(.fade(1.0))]
				)
			}
			return imageView
		})
		mainStackView.addArrangeSubviews(imageViews)
	}
	
	func clear() {
		mainStackView.arrangedSubviews
			.forEach({ $0.removeFromSuperview() })
	}
	
	private func initView() {
		snp.makeConstraints { make in
			make.height.equalTo(screenshotWidth * Self.sizeRatio)
		}
		addSubview(mainScrollView)
		mainScrollView.snp.makeConstraints { make in
			make.height.equalToSuperview()
			make.edges.equalToSuperview()
		}
		
		mainScrollView.addSubview(mainStackView)
		mainStackView.snp.makeConstraints { make in
			make.height.equalToSuperview()
			make.edges.equalToSuperview()
		}
		
		mainScrollView.contentSize = mainStackView.frame.size
	}
}
