import CommonData

final class DefaultSearchedTermRepository: SearchedTermRepository {
	init(store: UserDefaultsStore) {
		self.store = store
	}
	
	private let store: UserDefaultsStore
	
	func getSearchedTerms() -> [String] {
		guard let terms: [String] = store.findRawValue(for: UserDefaultsKey.terms.rawValue) else {
			return []
		}
		return terms
	}
	
	func updateSearchedTerms(terms: [String]) {
		store.saveRawValue(terms, for: UserDefaultsKey.terms.rawValue)
	}
}
