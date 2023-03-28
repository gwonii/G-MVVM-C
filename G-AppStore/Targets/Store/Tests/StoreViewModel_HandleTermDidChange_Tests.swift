import XCTest
@testable import Store
import CommonUI
import Combine

final class StoreViewModel_HandleTermDidChange_Tests: XCTestCase {
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
	
	/// #case1. 검색바에 빈 문자열을 입력한 경우
	///
	/// - condition1. searchBar에 빈문자열을 입력
	/// - result: autoCompeltion 에 emptyMessage 방출
	func testHandleTermDidChange_withTermIsEmpty() throws {
		let expectation = self.expectation(description: "Completed")
		var target: StoreSearchSection?
		let expected: StoreSearchSection = .init(
			kindsOfSection: .autoCompletion,
			items: [.emptyView(message: StoreSearchKindsOfSection.autoCompletion.emptyMessage)]
		)
		
		/// #given
		sut = makeViewModel_withTermIsEmpty()
		
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
				expectation.fulfill()
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
		termSubject.send("")
		waitForExpectations(timeout: 1.0)
		
		/// #then
		XCTAssertEqual(target, expected, "target: \(String(describing: target))")
	}

	/// #case2. 검색바에 문자열을 입력하는 경우
	///
	/// - condition1. searchBar에 "kakaoBank" 입력
	/// - condition2. 최근 검색어 "kakaoBank", "kakao"
	/// - result: autoCompeltion 에 "kakaoBank" 방출
	func testHandleTermDidChange_withSameTerm() throws {
		let expectation = self.expectation(description: "Completed")
		var target: StoreSearchSection?
		let expected: StoreSearchSection = .init(
			kindsOfSection: .autoCompletion,
			items: [.autoCompletion(term: "kakaoBank")]
		)
		var emitCount: Int = 0
		
		/// #given
		sut = makeViewModel_withSameTerm()
		
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
				if emitCount >= 2 {
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
		termSubject.send("kakaoBank") // emitCount -> 2
		waitForExpectations(timeout: 1.0)
		
		/// #then
		XCTAssertEqual(target, expected, "target: \(String(describing: target))")
	}
	
	/// #case3. 검색바에 최근 검색어에 동일한 문자가 포함된 검색어를 입력하는 경우
	///
	/// - condition1. searchBar에 "kaka" 입력
	/// - condition2. 최근 검색어 "kakaoBank", "kakao"
	/// - result: autoCompeltion 에 "kakaoBank", "kakao" 방출
	func testHandleTermDidChange_withIncludedTerm() throws {
		let expectation = self.expectation(description: "Completed")
		var target: StoreSearchSection?
		let expected: StoreSearchSection = .init(
			kindsOfSection: .autoCompletion,
			items: [.autoCompletion(term: "kakaoBank"), .autoCompletion(term: "kakao")]
		)
		var emitCount: Int = 0
		
		/// #given
		sut = makeViewModel_withIncludedTerm()
		
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
				if emitCount >= 2 {
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
		
		/// when
		lifeCycleSubject.send(.viewDidLoad) // emitCount -> 1
		termSubject.send("kakao") // emitCount -> 2
		waitForExpectations(timeout: 1.0)
		
		/// then
		XCTAssertEqual(target, expected, "target: \(String(describing: target))")
	}
	
	/// #case4. 검색바에 최근 검색어와 일치하지 않는 검색어 입력하는 경우
	///
	/// - condition1. searchBar에 "swift" 입력
	/// - condition2. 최근 검색어 "kakaoBank", "kakao"
	/// - result: autoCompeltion 에 empty message 방출
	func testHandleTermDidChange_withoutIncludedTerm() throws {
		let expectation = self.expectation(description: "Completed")
		var target: StoreSearchSection?
		let expected: StoreSearchSection = .init(
			kindsOfSection: .autoCompletion,
			items: [.emptyView(message: StoreSearchKindsOfSection.autoCompletion.emptyMessage)]
		)
		var emitCount: Int = 0
		
		/// #given
		sut = makeViewModel_withoutIncludedTerm()
		
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
				if emitCount >= 2 {
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
		termSubject.send("swift") // emitCount -> 2
		waitForExpectations(timeout: 1.0)
		
		/// #then
		XCTAssertEqual(target, expected, "target: \(String(describing: target))")
	}
	
	private func makeViewModel_withTermIsEmpty() -> StoreViewModel {
		let coordinator: StoreCoordinator = MockStoreCoordinator()
		let trackRepository: trackRepository = StubNoTrackRepository()
		let searchedTermRepository: SearchedTermRepository = StubNoSearchedTermRepository()
		
		let generator = StoreViewModelGenrator()
		return generator(
			coordinator: coordinator,
			trackRepository: trackRepository,
			searchedTermRepository: searchedTermRepository
		)
	}
	
	private func makeViewModel_withSameTerm() -> StoreViewModel {
		let coordinator: StoreCoordinator = MockStoreCoordinator()
		let trackRepository: trackRepository = StubNoTrackRepository()
		let searchedTermRepository: SearchedTermRepository = StubTwoSearchedTermRepository()
		
		let generator = StoreViewModelGenrator()
		return generator(
			coordinator: coordinator,
			trackRepository: trackRepository,
			searchedTermRepository: searchedTermRepository
		)
	}
	
	private func makeViewModel_withIncludedTerm() -> StoreViewModel {
		let coordinator: StoreCoordinator = MockStoreCoordinator()
		let trackRepository: trackRepository = StubNoTrackRepository()
		let searchedTermRepository: SearchedTermRepository = StubTwoSearchedTermRepository()
		
		return viewModelGenerator(
			coordinator: coordinator,
			trackRepository: trackRepository,
			searchedTermRepository: searchedTermRepository
		)
	}
	
	private func makeViewModel_withoutIncludedTerm() -> StoreViewModel {
		let coordinator: StoreCoordinator = MockStoreCoordinator()
		let trackRepository: trackRepository = StubNoTrackRepository()
		let searchedTermRepository: SearchedTermRepository = StubTwoSearchedTermRepository()
		
		return viewModelGenerator(
			coordinator: coordinator,
			trackRepository: trackRepository,
			searchedTermRepository: searchedTermRepository
		)
	}
}
