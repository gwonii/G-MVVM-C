import Combine

protocol trackRepository {
	func getTrackSearchResult(term: String) -> AnyPublisher<[Track], Error>
}
