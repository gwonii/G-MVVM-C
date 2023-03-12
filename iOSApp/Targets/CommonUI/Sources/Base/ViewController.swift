import UIKit
import Combine
import Lottie
import Common

open class ViewController: UIViewController {
	public init() {
		super.init(nibName: nil, bundle: nil)
		initViews()
		initBind()
	}
	public required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private let _isBusySubject: CurrentValueSubject<Bool, Never> = .init(false)
	public var isBusyPublisher: AnyPublisher<Bool, Never> {
		return _isBusySubject.eraseToAnyPublisher()
	}
	public var isBusy: Bool {
		return _isBusySubject.value
	}

	private let _viewDidLoadSubject: CurrentValueSubject<Void, Never> = .init(())
	public var viewDidLoadPublisher: AnyPublisher<Void, Never> {
		return _viewDidLoadSubject.eraseToAnyPublisher()
	}

	private let _viewWillAppearSubject: PassthroughSubject<Void, Never> = .init()
	public var viewWillAppearPublisher: AnyPublisher<Void, Never> {
		return _viewWillAppearSubject.eraseToAnyPublisher()
	}

	private let _viewWillDisappearSubject: PassthroughSubject<Void, Never> = .init()
	public var viewWillDisappearPublisher: AnyPublisher<Void, Never> {
		return _viewWillDisappearSubject.eraseToAnyPublisher()
	}

	private let _viewDidDisappearSubject: PassthroughSubject<Void, Never> = .init()
	public var viewDidDisappearPublisher: AnyPublisher<Void, Never> {
		return _viewDidDisappearSubject.eraseToAnyPublisher()
	}

	private let activityIndicator: LottieAnimationView = {
		let view: LottieAnimationView = .init(name: "loading")
		view.loopMode = .loop
		return view
	}()

	public var cancellables: Set<AnyCancellable> = .init()

	open override func viewDidLoad() {
		super.viewDidLoad()
		Logger.info("\(self) viewDidLoad is called")
		_viewDidLoadSubject.send(())
	}
	open override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		Logger.info("\(self) viewWillAppear is called")
		_viewWillAppearSubject.send(())
	}
	open override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		Logger.info("\(self) viewWillDisappear is called")
		_viewWillDisappearSubject.send(())
	}
	open override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		Logger.info("\(self) viewDidDisappear is called")
		_viewDidDisappearSubject.send(())
	}

	public func setBusy(_ isBusy: Bool) {
		_isBusySubject.send(isBusy)
	}

	open func initViews() {
		view.addSubview(activityIndicator)
		view.bringSubviewToFront(activityIndicator)
		activityIndicator.snp.makeConstraints({ (maker) in
			maker.size.equalTo(60)
			maker.center.equalToSuperview()
		})
	}

	private func initBind() {
		isBusyPublisher
			.sink(receiveValue: { [weak self] (isBusy) in
				if isBusy {
					self?.activityIndicator.isHidden = false
					self?.activityIndicator.play()
				} else {
					self?.activityIndicator.isHidden = true
					self?.activityIndicator.play()
				}
			})
			.store(in: &cancellables)
	}
}
