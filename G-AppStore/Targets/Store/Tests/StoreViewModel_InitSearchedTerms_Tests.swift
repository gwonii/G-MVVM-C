import XCTest
@testable import Store
import CommonUI
import Combine

final class StoreViewModel_InitSearchedTerms_Tests: XCTestCase {
	private let viewModelGenerator: StoreViewModelGenrator = .init()
	private let outputGenerator: StoreOutputGenerator = .init()
	
	private var cancellables: Set<AnyCancellable> = .init()
	private var sut: StoreViewModel!
	
	/// - HomeList Input
	private var lifeCycleSubject: CurrentValueSubject<ViewControllerLifeCycle, Never>!
	private var didSelectItemSubject: PassthroughSubject<StoreSearchSection, Never>!
	
	override func setUp() {
		super.setUp()
		cancellables = .init()
		lifeCycleSubject = .init(.initialize)
		didSelectItemSubject = .init()
	}
	
	/// #case1. 최근 검색어가 없는 경우를 테스트 합니다.
	///
	/// - condition1. viewDidLoad 호출시
	/// - condition2. 최근 검색어가 없는 경우
	/// - result: recentlySearch 에 empty message 방출
	func testInitSearchedTerms_withNoSearchedTemrs() throws {
		let expectation = self.expectation(description: "Completed")
		var target: StoreSearchSection?
		let expected: StoreSearchSection = .init(
			kindsOfSection: .recentlySearch,
			items: [.emptyView(message: StoreSearchKindsOfSection.recentlySearch.emptyMessage)]
		)
		
		/// given
		sut = makeViewModel_withNoSearchedTemrs()
		let output = outputGenerator(
			lifeCycle: lifeCycleSubject,
			didSelectItem: didSelectItemSubject,
			viewModel: &sut
		)
		
		output.cancellables
			.forEach({ $0.store(in: &cancellables) })
		output.collectionViewSection
			.sink(receiveValue: { (section) in
				target = section
				expectation.fulfill()
			})
			.store(in: &cancellables)
		
		/// when
		lifeCycleSubject.send(.viewDidLoad)
		waitForExpectations(timeout: 1.0)
		
		/// then
		XCTAssertEqual(target, expected, "target: \(String(describing: target))")
	}
	
	/// #case2. 최근 검색어가 있는 경우를 테스트 합니다.
	///
	/// - condition1. viewDidLoad 호출시
	/// - condition2. 최근 검색어가 있는 경우
	/// - result: recentlySearch 에 "kakaoBank", "kakao" 방출
	func testInitSearchedTerms_withTwoSearchedTemrs() throws {
		let expectation = self.expectation(description: "Completed")
		var target: StoreSearchSection?
		let expected: StoreSearchSection = .init(
			kindsOfSection: .recentlySearch,
			items: [.recentlySearch(term: "kakaoBank"), .recentlySearch(term: "kakao")]
		)
		
		/// given
		sut = makeViewModel_withTwoSearchedTemrs()
		let output = outputGenerator(
			lifeCycle: lifeCycleSubject,
			didSelectItem: didSelectItemSubject,
			viewModel: &sut
		)
		
		output.cancellables
			.forEach({ $0.store(in: &cancellables) })
		output.collectionViewSection
			.sink(receiveValue: { (section) in
				target = section
				expectation.fulfill()
			})
			.store(in: &cancellables)
		
		/// when
		lifeCycleSubject.send(.viewDidLoad)
		waitForExpectations(timeout: 1.0)
		
		/// then
		XCTAssertEqual(target, expected, "target: \(String(describing: target))")
	}
	
	private func makeViewModel_withNoSearchedTemrs() -> StoreViewModel {
		let coordinator: StoreCoordinator = MockStoreCoordinator()
		let trackRepository: trackRepository = StubNoTrackRepository()
		let searchedTermRepository: SearchedTermRepository = StubNoSearchedTermRepository()
		
		return viewModelGenerator(
			coordinator: coordinator,
			trackRepository: trackRepository,
			searchedTermRepository: searchedTermRepository
		)
	}
	
	private func makeViewModel_withTwoSearchedTemrs() -> StoreViewModel {
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
