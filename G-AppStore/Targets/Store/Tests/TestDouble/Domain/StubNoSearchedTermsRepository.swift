@testable import Store

final class StubNoSearchedTermRepository: SearchedTermRepository {
	func getSearchedTerms() -> [String] {
		return []
	}
	
	func updateSearchedTerms(terms: [String]) {
		return
	}
}
