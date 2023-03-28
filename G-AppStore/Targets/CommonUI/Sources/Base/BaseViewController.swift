import class UIKit.UIViewController
import class UIKit.NSCoder
import class UIKit.UIActivityIndicatorView
import Combine
import SnapKit

open class BaseViewController<
	Input, Output,
	RootView: BaseRootView<Input>,
	ViewModel: BaseViewModel<Input, Output>
>: UIViewController {
	public typealias Input = Input
	public typealias Output = Output
	public typealias RootView = RootView
	public typealias ViewModel = ViewModel
	
	public init(viewModel: ViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
		initViews()
		initBind()
	}
	public required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	public var cancellables: Set<AnyCancellable> = .init()
	public private(set) var viewModel: ViewModel
	open private(set) var rootView: RootView!
	
	private let lifeCycleSubject: CurrentValueSubject<ViewControllerLifeCycle, Never> = .init(.initialize)
	public var lifeCyclePublisher: AnyPublisher<ViewControllerLifeCycle, Never> {
		return lifeCycleSubject.eraseToAnyPublisher()
	}
	
	private let activityIndicator: UIActivityIndicatorView = .init(style: .large)

	open override func viewDidLoad() {
		super.viewDidLoad()
		lifeCycleSubject.send(.viewDidLoad)
	}
	open override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		lifeCycleSubject.send(.viewWillAppear)
	}
	open override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		lifeCycleSubject.send(.viewDidAppear)
	}
	open override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		lifeCycleSubject.send(.viewWillDisappear)
	}
	open override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		lifeCycleSubject.send(.viewDidDisappear)
	}
	
	open func initViews() {
		rootView.addSubview(activityIndicator)
		rootView.bringSubviewToFront(activityIndicator)
		activityIndicator.snp.makeConstraints({ (maker) in
			maker.size.equalTo(40)
			maker.center.equalToSuperview()
		})
	}

	private func initBind() {
		viewModel.isBusyPublisher
			.sink(receiveValue: { [weak self] (isBusy) in
				if isBusy {
					self?.activityIndicator.isHidden = false
					self?.activityIndicator.startAnimating()
				} else {
					self?.activityIndicator.isHidden = true
					self?.activityIndicator.stopAnimating()
				}
			})
			.store(in: &cancellables)
	}
}
