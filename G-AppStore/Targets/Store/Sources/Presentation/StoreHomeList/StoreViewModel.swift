import Foundation
import Combine
import CommonUI

final class StoreViewModel: BaseViewModel<
StoreInput,
StoreOutput
> {
	init(coordinator: StoreCoordinator, dependencies: StoreDependencies) {
		self.coordinator = coordinator
		self.dependencies = dependencies
	}
	
	private let coordinator: StoreCoordinator
	private let dependencies: StoreDependencies
	
	@Published
	private var searchedTerms: [String] = []
	@Published
	private var collectionViewSection: StoreSearchSection?
	
	override func transform(_ input: Input) -> Output {
		let cancellables: Set<AnyCancellable> =
		Set(
			[
				initSearchedTerms(input),
				handleDidSelectItem(input)
			].compactMap({ $0 })
		)
		
		let output: Output = .init(
			cancellables: cancellables,
			collectionViewSection: $collectionViewSection
				.compactMap({ $0 })
				.eraseToAnyPublisher()
		)
		return output
	}
}

/// Handle Main Event
extension StoreViewModel {
	private func initSearchedTerms(_ input: Input) -> AnyCancellable? {
		return input.lifeCycle?
			.filter({ $0 == .viewDidLoad })
			.map({ [weak self] _ -> [String] in
				guard let existingSearchedTerms: [String] = self?.dependencies.searchedTermRepository.getSearchedTerms() else {
					return []
				}
				return existingSearchedTerms
			})
			.handleEvents(receiveOutput: { [weak self] (terms) in
				self?.searchedTerms = terms
			})
			.map({ (terms) -> StoreSearchSection in
				if terms.isEmpty {
					return .init(
						kindsOfSection: .recentlySearch,
						items: [StoreSearchKindsOfItem.emptyView(message: StoreSearchKindsOfSection.recentlySearch.emptyMessage)]
					)
				} else {
					return .init(
						kindsOfSection: .recentlySearch,
						items: terms.map({ StoreSearchKindsOfItem.recentlySearch(term: $0) })
					)
				}
			})
			.assignNoRetain(to: \.collectionViewSection, on: self)
	}
	
	private func handleDidSelectItem(_ input: Input) -> AnyCancellable {
		return input.didSelectItem
			.flatMap({ [weak self] (section) -> AnyPublisher<StoreSearchSection?, Never> in
				guard let self else { return Just(nil).eraseToAnyPublisher() }
				switch section.kindsOfSection {
					case .recentlySearch, .autoCompletion:
						if case .recentlySearch(let term) = section.items.first {
							return self.fetchTracksAndMakeSection(term: term)
								.compactMap({ $0 })
								.eraseToAnyPublisher()
						}
						if case .autoCompletion(let term) = section.items.first {
							return self.fetchTracksAndMakeSection(term: term)
								.compactMap({ $0 })
								.eraseToAnyPublisher()
						}
					case .track:
						guard case .track(let track) = section.items.first else {
							return Just(nil).eraseToAnyPublisher()
						}
						self.coordinator.presenttrackDetailView(track: track)
				}
				return Just(nil).eraseToAnyPublisher()
			})
			.compactMap({ $0 })
			.assignNoRetain(to: \.collectionViewSection, on: self)
	}
}

/// Handle SearchBarController Event
extension StoreViewModel {
	func transform(_ input: SearchBarInput) -> SearchBarOutput {
		let cancellables: Set<AnyCancellable> = [
			handleTermDidChange(input),
			handleSearchButtonEvent(input),
			handleSearchCancelButtonEvent(input)
		]
		return .init(cancellables: cancellables)
	}

	private func handleTermDidChange(_ input: SearchBarInput) -> AnyCancellable {
		return input.term
			.compactMap({ [weak self] (term) -> [String]? in
				return self?.searchedTerms.filter({ $0.contains(term) })
			})
			.map({ (terms) -> StoreSearchSection in
				if terms.isEmpty {
					return .init(
						kindsOfSection: .autoCompletion,
						items: [StoreSearchKindsOfItem.emptyView(message: StoreSearchKindsOfSection.autoCompletion.emptyMessage)]
					)
				}
				return .init(
					kindsOfSection: .autoCompletion,
					items: terms.map({ StoreSearchKindsOfItem.autoCompletion(term: $0) })
				)
			})
			.assignNoRetain(to: \.collectionViewSection, on: self)
	}
	
	private func handleSearchButtonEvent(_ input: SearchBarInput) -> AnyCancellable {
		return input.searchButtonTapped
			.handleEvents(receiveOutput: { [weak self] (term) in
				guard let self else { return }
				self.setBusy(true)
				self.searchedTerms.removeAll(where: { $0 == term })
				self.searchedTerms.insert(term, at: 0)
				self.dependencies.searchedTermRepository.updateSearchedTerms(terms: self.searchedTerms)
			})
			.flatMap({ [weak self] (term) -> AnyPublisher<StoreSearchSection, Never> in
				guard let self else {
					return Just(
						StoreSearchSection(
							kindsOfSection: .track,
							items: [StoreSearchKindsOfItem.emptyView(message: StoreSearchKindsOfSection.track.emptyMessage)]
						)
					).eraseToAnyPublisher()
				}
				return self.fetchTracksAndMakeSection(term: term)
			})
			.compactMap({ $0 })
			.assignNoRetain(to: \.collectionViewSection, on: self)
	}
	
	private func handleSearchCancelButtonEvent(_ input: SearchBarInput) -> AnyCancellable {
		return input.searchCancelButtonTapped
			.compactMap({ [weak self] _ -> StoreSearchSection? in
				guard let self else { return nil }
				if self.searchedTerms.isEmpty {
					return .init(
						kindsOfSection: .recentlySearch,
						items: [StoreSearchKindsOfItem.emptyView(message: "최근 검색 결과가 없습니다.")]
					)
				} else {
					return .init(
						kindsOfSection: .recentlySearch,
						items: self.searchedTerms.map({ StoreSearchKindsOfItem.recentlySearch(term: $0) })
					)
				}
			})
			.assignNoRetain(to: \.collectionViewSection, on: self)
	}
	
	private func fetchTracksAndMakeSection(term: String) -> AnyPublisher<StoreSearchSection, Never> {
		return dependencies.trackRepository
			.getTrackSearchResult(term: term)
			.receive(on: DispatchQueue.main)
			.handleEvents(receiveRequest: { [weak self] _ in
				self?.setBusy(true)
			})
			.catch { error -> AnyPublisher<[Track], Never> in
				print(error)
				return Just([]).eraseToAnyPublisher()
			}
			.map { tracks -> StoreSearchSection in
				self.setBusy(false)
				if tracks.isEmpty {
					return .init(
						kindsOfSection: .track,
						items: [StoreSearchKindsOfItem.emptyView(message: StoreSearchKindsOfSection.track.emptyMessage)]
					)
				} else {
					return .init(
						kindsOfSection: .track,
						items: tracks.map { StoreSearchKindsOfItem.track(track: $0) }
					)
				}
			}
			.eraseToAnyPublisher()
	}
}
