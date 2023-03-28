import struct UIKit.CGFloat
import class UIKit.NSCoder
import class UIKit.UIBarButtonItem
import Dispatch
import Combine
import CommonUI

final class StoreViewController: BaseViewController<
StoreInput,
StoreOutput,
StoreRootView,
StoreViewModel
> {
	private let searchBarController: SearchBarController = .init()
	private let navigationItemBackButton: UIBarButtonItem = .init()
	
	override init(viewModel: ViewModel) {
		super.init(viewModel: viewModel)
		bindAll()
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
		
		setupSearchBarController()
		initViews()
	}
	
	override func initViews() {
		super.initViews()
		view.backgroundColor = BaseColor.black.color
		
		view.addSubview(rootView)
		rootView.snp.makeConstraints { make in
			make.top.equalToSuperview()
			make.horizontalEdges.equalToSuperview()
			make.bottom.equalToSuperview()
		}
	}
	
	private func bindAll() {
		var mainInput: Input = rootView.makeInput()
		mainInput.lifeCycle = lifeCyclePublisher
		let mainOutput: Output = viewModel.transform(mainInput)
		bind(mainOutput)
		
		let searchBarInput: SearchBarInput = searchBarController.makeInput()
		let searchBarOutput: SearchBarOutput = viewModel.transform(searchBarInput)
		bind(searchBarOutput)
	}
	
	private func bind(_ output: Output) {
		output.cancellables.forEach({ $0.store(in: &cancellables) })
		
		output
			.collectionViewSection
			.receive(on: DispatchQueue.main)
			.sink(receiveValue: rootView.applySnapshot(_:))
			.store(in: &cancellables)
		
		rootView.collectionViewDidScrollPublisher
			.sink(receiveValue: setNavigationItemDisplayMode(offsetY:))
			.store(in: &cancellables)
	}
	
	private func setNavigationItemDisplayMode(offsetY: CGFloat) {
		let currentMode = navigationController?.navigationItem.largeTitleDisplayMode
		
		if offsetY > 0 && currentMode != .never {
			navigationController?.navigationBar.prefersLargeTitles = false
			navigationItem.largeTitleDisplayMode = .never
		} else if currentMode != .always && offsetY <= 0 {
			navigationController?.navigationBar.prefersLargeTitles = true
			navigationItem.largeTitleDisplayMode = .always
		}
	}
	
	private func setupSearchBarController() {
		let title: String = "검색"
		navigationItem.searchController = searchBarController
		navigationItem.title = title
		navigationItem.hidesSearchBarWhenScrolling = false
		navigationItem.largeTitleDisplayMode = .always
		
		navigationItemBackButton.title = title
		navigationItemBackButton.tintColor = BaseColor.blue.color
		navigationItem.backBarButtonItem = navigationItemBackButton
	}
}
/// Bind SearchBarController
extension StoreViewController {
	func bind(_ output: SearchBarOutput) {
		output.cancellables.forEach({ $0.store(in: &cancellables) })
	}
}
