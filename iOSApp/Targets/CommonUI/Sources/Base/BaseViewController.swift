import UIKit
import Combine
import SnapKit

open class BaseViewController<
	Input, Output,
	Coordinator: BaseCoordinator,
	RootView: BaseRootView<Input>,
	ViewModel: BaseViewModel<Input, Output, Coordinator>
>: ViewController
{
	public typealias Input = Input
	public typealias Output = Output
	public typealias RootView = RootView
	public typealias ViewModel = ViewModel
	public typealias Coordinator = Coordinator
	public private(set) var viewModel: ViewModel
	open weak private(set) var rootView: RootView!

	public init(viewModel: ViewModel) {
		self.viewModel = viewModel
		super.init()
	}
	public required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	open override func initViews() {
		super.initViews()
		view.addSubview(rootView)
		rootView.snp.makeConstraints({ (maker) in
			maker.edges.equalToSuperview()
		})
	}

	private func initBind() {
		viewModel.isBusyPublisher
			.sink(receiveValue: self.setBusy(_:))
			.store(in: &cancellables)
	}
}
