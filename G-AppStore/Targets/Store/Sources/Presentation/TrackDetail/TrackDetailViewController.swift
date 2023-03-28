import class UIKit.NSCoder
import Combine
import CommonUI

final class TrackDetailViewController: BaseViewController<
TrackDetailInput,
TrackDetailOutput,
TrackDetailRootView,
TrackDetailViewModel
> {
	override init(viewModel: ViewModel) {
		super.init(viewModel: viewModel)

		let input: Input = rootView.makeInput()
		let output: Output = viewModel.transform(input)
		bind(output)
	}
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private let _rootView: RootView = .init()
	override var rootView: RootView! {
		return _rootView
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		
		initViews()
	}
	
	override func initViews() {
		super.initViews()
		view.backgroundColor = BaseColor.black.color
		
		view.addSubview(rootView)
		rootView.snp.makeConstraints { make in
			make.top.equalTo(view.safeAreaLayoutGuide)
			make.leading.trailing.bottom.equalToSuperview()
		}
	}

	private func bind(_ output: Output) {
		output.cancellables.forEach({ $0.store(in: &cancellables) })
		
		output.track
			.sink(receiveValue: { [weak rootView] (track) in
				rootView?.setup(track: track)
			})
			.store(in: &cancellables)
	}
}
