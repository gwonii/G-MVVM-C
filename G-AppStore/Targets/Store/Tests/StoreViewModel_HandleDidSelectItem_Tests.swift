import XCTest
@testable import Store
import CommonUI
import Combine

final class StoreViewModel_HandleDidSelectItem_Tests: XCTestCase {
	private let entityGenerator: EntityGenerator = .init()
	private let viewModelGenerator: StoreViewModelGenrator = .init()
	private let storeOutputGenerator: StoreOutputGenerator = .init()
	private let searchBarOutputGenerator: SearchBarOutputGenerator = .init()
	
	private var cancellables: Set<AnyCancellable> = .init()
	private var sut: StoreViewModel!
	
	/// - HomeList Input
	private var lifeCycleSubject: CurrentValueSubject<ViewControllerLifeCycle, Never>!
	private var didSelectItemSubject: PassthroughSubject<StoreSearchSection, Never>!
	
	/// - SearchBar Input
	private var termSubject: PassthroughSubject<String, Never>!
	private var searchButtonTappedSubject: PassthroughSubject<String, Never>!
	private var searchCancelButtonTappedSubject: PassthroughSubject<Void, Never>!
	
	private let coordinator: MockStoreCoordinator = MockStoreCoordinator()

	override func setUp() {
		super.setUp()
		cancellables = .init()
		
		lifeCycleSubject = .init(.initialize)
		didSelectItemSubject = .init()
		
		termSubject = .init()
		searchButtonTappedSubject = .init()
		searchCancelButtonTappedSubject = .init()
	}
	
	/// #case1. 검색 결과에서 cell 클릭한 경우
	///
	/// - condition1. "카카오뱅크" cell 클릭
	/// - result: 검색결과 화면에서 "카카오뱅크" 상세화면으로 이동
	func testHandleDidSelectItem() throws {
		let expectedItunesResult: ItunesResult! = entityGenerator("ItunesMockData", fileType: "json")
		var emitCount: Int = 0
		
		/// #given
		sut = makeViewModel()
		
		/// - HomeList
		let mainOutput = storeOutputGenerator(
			lifeCycle: lifeCycleSubject,
			didSelectItem: didSelectItemSubject,
			viewModel: &sut
		)
		mainOutput.cancellables
			.forEach({ $0.store(in: &cancellables) })
		mainOutput.collectionViewSection
			.sink(receiveValue: { (section) in
				emitCount += 1
			})
			.store(in: &cancellables)
		
		/// - SearchBar Event
		let searchBarOutput = searchBarOutputGenerator(
			termSubject: termSubject,
			searchButtonTappedSubject: searchButtonTappedSubject,
			searchCancelButtonTappedSubject: searchCancelButtonTappedSubject,
			viewModel: &sut
		)
		searchBarOutput.cancellables
			.forEach({ $0.store(in: &cancellables) })
		
		/// #when
		lifeCycleSubject.send(.viewDidLoad) // emitCount -> 1
		termSubject.send("kakaoBank") // emitCount -> 2
		searchButtonTappedSubject.send("kakaoBank") // emitCount -> 3
		didSelectItemSubject.send(.init(
			kindsOfSection: .track,
			items: [StoreSearchKindsOfItem.track(track: .init(from: expectedItunesResult))]
		))
		sleep(2)
		
		/// #then
		XCTAssertEqual(emitCount, 3, "target: \(String(describing: emitCount))")
		let target: Int = coordinator.presenttrackDetailViewDidCalledCount
		let expected: Int = 1
		XCTAssertEqual(target, expected, "target: \(String(describing: target))")
	}
	
	private func makeViewModel() -> StoreViewModel {
		let trackRepository: trackRepository = StubOneTrackRepository()
		let searchedTermRepository: SearchedTermRepository = StubTwoSearchedTermRepository()
		return viewModelGenerator(
			coordinator: coordinator,
			trackRepository: trackRepository,
			searchedTermRepository: searchedTermRepository
		)
	}
}
