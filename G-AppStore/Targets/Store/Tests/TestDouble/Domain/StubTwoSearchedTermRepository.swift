@testable import Store

final class StubTwoSearchedTermRepository: SearchedTermRepository {
	func getSearchedTerms() -> [String] {
		return ["kakaoBank", "kakao"]
	}
	
	func updateSearchedTerms(terms: [String]) {
		return
	}
}
