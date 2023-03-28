import XCTest
@testable import Store
import CommonUI
import Combine

final class StoreViewModel_HandleSearchCancelButtonEvent_Tests: XCTestCase {
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

	/// #case1. 검색어 입력중에 검색 취소 누르는 경우
	///
	/// - condition1. searchBar에 "kakao" 입력
	/// - condition2. searchBar cancel button 입력
	/// - condition3. 최근 검색어에 "kakaoBank", "kakao"
	/// - result: recentlySearch 에 "kakaoBank", "kakao" 방출
	func testHandleSearchCancelButtonEvent_withRecentlySearchedTerms() throws {
		let expectation = self.expectation(description: "Completed")
		var target: StoreSearchSection?
		let expected: StoreSearchSection = .init(
			kindsOfSection: .recentlySearch,
			items: [.recentlySearch(term: "kakaoBank"), .recentlySearch(term: "kakao")]
		)
		var emitCount: Int = 0
		
		/// #given
		sut = makeViewModel_withRecentlySearchedTerms()
		
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
		
		/// - SearchBar
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
		termSubject.send("kakao") // emitCount -> 2
		searchCancelButtonTappedSubject.send(()) // emitCount -> 3
		waitForExpectations(timeout: 1.0)
		
		/// #then
		XCTAssertEqual(target, expected, "target: \(String(describing: target))")
	}
	
	/// #case2. 검색어 입력중에 검색 취소 누르는 경우
	///
	/// - condition1. searchBar에 "kakao" 입력
	/// - condition2. searchBar cancel button 입력
	/// - condition3. 최근 검색어에 아무것도 없음
	/// - result: recentlySearch 에 empty message 방출
	func testHandleSearchCancelButtonEvent_withoutRecentlySearchedTerms() throws {
		let expectation = self.expectation(description: "Completed")
		var target: StoreSearchSection?
		let expected: StoreSearchSection = .init(
			kindsOfSection: .recentlySearch,
			items: [.emptyView(message: StoreSearchKindsOfSection.recentlySearch.emptyMessage)]
		)
		var emitCount: Int = 0
		
		/// #given
		sut = makeViewModel_withoutRecentlySearchedTerms()
		
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
		termSubject.send("kakao") // emitCount -> 2
		searchCancelButtonTappedSubject.send(()) // emitCount -> 3
		waitForExpectations(timeout: 1.0)
		
		/// then
		XCTAssertEqual(target, expected, "target: \(String(describing: target))")
	}
	
	private func makeViewModel_withRecentlySearchedTerms() -> StoreViewModel {
		let coordinator: StoreCoordinator = MockStoreCoordinator()
		let trackRepository: trackRepository = StubNoTrackRepository()
		let searchedTermRepository: SearchedTermRepository = StubTwoSearchedTermRepository()
		return viewModelGenerator(
			coordinator: coordinator,
			trackRepository: trackRepository,
			searchedTermRepository: searchedTermRepository
		)
	}
	
	private func makeViewModel_withoutRecentlySearchedTerms() -> StoreViewModel {
		let coordinator: StoreCoordinator = MockStoreCoordinator()
		let trackRepository: trackRepository = StubNoTrackRepository()
		let searchedTermRepository: SearchedTermRepository = StubNoSearchedTermRepository()
		return viewModelGenerator(
			coordinator: coordinator,
			trackRepository: trackRepository,
			searchedTermRepository: searchedTermRepository
		)
	}
}
