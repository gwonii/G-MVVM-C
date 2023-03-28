@testable import Store

final class StubStoreDependencies: StoreDependencies {
	init(
		trackRepository: trackRepository,
		searchedTermRepository: SearchedTermRepository
	) {
		self.trackRepository = trackRepository
		self.searchedTermRepository = searchedTermRepository
	}
	
	var trackRepository: trackRepository
	var searchedTermRepository: SearchedTermRepository
}
