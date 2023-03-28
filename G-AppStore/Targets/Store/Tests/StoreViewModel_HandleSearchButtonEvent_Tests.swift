import XCTest
@testable import Store
import CommonUI
import Combine

final class StoreViewModel_HandleSearchButtonEvent_Tests: XCTestCase {
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
	
	override func setUp() {
		super.setUp()
		cancellables = .init()
		
		lifeCycleSubject = .init(.initialize)
		didSelectItemSubject = .init()
		
		termSubject = .init()
		searchButtonTappedSubject = .init()
		searchCancelButtonTappedSubject = .init()
	}
	
	/// #case1. 검색 결과가 없는 경우
	///
	/// - condition1. searchBar에 "dfejvsf" 입력
	/// - result: track 에 emptyMessage 방출
	func testHandleSearchButtonEvent_withEmptytrack() throws {
		let expectation = self.expectation(description: "Completed")
		var target: StoreSearchSection?
		let expected: StoreSearchSection = .init(
			kindsOfSection: .track,
			items: [.emptyView(message: StoreSearchKindsOfSection.track.emptyMessage)]
		)
		var emitCount: Int = 0
		
		/// #given
		sut = makeViewModel_withEmptytrack()
		
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
				target = section
				emitCount += 1
				if emitCount >= 3 {
					expectation.fulfill()
				}
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
		termSubject.send("dfejvsf") // emitCount -> 2
		searchButtonTappedSubject.send("dfejvsf") // emitCount -> 3
		waitForExpectations(timeout: 1.0)
		
		/// #then
		XCTAssertEqual(target, expected, "target: \(String(describing: target))")
	}

	/// #case2. 검색 결과가 있는 경우
	///
	/// - condition1. searchBar에 "kakaoBank" 입력
	/// - condition2. 검색결과는 한 개로 제한한다.
	/// - result: track 에 "kakaoBank" 방출
	func testHandleSearchButtonEvent_withtrack() throws {
		let expectation = self.expectation(description: "Completed")
		
		var target: StoreSearchSection?
		let expectedItunesResult: ItunesResult! = entityGenerator("ItunesMockData", fileType: "json")
		let expected: StoreSearchSection = .init(
			kindsOfSection: .track,
			items: [.track(track: .init(from: expectedItunesResult))]
		)
		var emitCount: Int = 0
		
		/// #given
		sut = makeViewModel_withtrack()
		
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
				target = section
				emitCount += 1
				if emitCount >= 3 {
					expectation.fulfill()
				}
			})
			.store(in: &cancellables)
		
		/// SearchBar Event
		let searchBarOutput = searchBarOutputGenerator(
			termSubject: termSubject,
			searchButtonTappedSubject: searchButtonTappedSubject,
			searchCancelButtonTappedSubject: searchCancelButtonTappedSubject,
			viewModel: &sut
		)
		searchBarOutput.cancellables
			.forEach({ $0.store(in: &cancellables) })
		
		/// when
		lifeCycleSubject.send(.viewDidLoad) // emitCount -> 1
		termSubject.send("kakaoBank") // emitCount -> 2
		searchButtonTappedSubject.send("kakaoBank") // emitCount -> 3
		waitForExpectations(timeout: 1.0)
		
		/// then
		XCTAssertEqual(target, expected, "target: \(String(describing: target))")
	}
	
	private func makeViewModel_withEmptytrack() -> StoreViewModel {
		let coordinator: StoreCoordinator = MockStoreCoordinator()
		let trackRepository: trackRepository = StubNoTrackRepository()
		let searchedTermRepository: SearchedTermRepository = StubNoSearchedTermRepository()
		return viewModelGenerator(
			coordinator: coordinator,
			trackRepository: trackRepository,
			searchedTermRepository: searchedTermRepository
		)
	}
	
	private func makeViewModel_withtrack() -> StoreViewModel {
		let coordinator: StoreCoordinator = MockStoreCoordinator()
		let trackRepository: trackRepository = StubOneTrackRepository()
		let searchedTermRepository: SearchedTermRepository = StubNoSearchedTermRepository()
		return viewModelGenerator(
			coordinator: coordinator,
			trackRepository: trackRepository,
			searchedTermRepository: searchedTermRepository
		)
	}
}
