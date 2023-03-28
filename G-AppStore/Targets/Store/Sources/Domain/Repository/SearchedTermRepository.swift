protocol SearchedTermRepository {
	func getSearchedTerms() -> [String]
	func updateSearchedTerms(terms: [String])
}
