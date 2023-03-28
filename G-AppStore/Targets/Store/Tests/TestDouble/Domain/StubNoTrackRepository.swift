@testable import Store
import Combine

final class StubNoTrackRepository: trackRepository {
	func getTrackSearchResult(term: String) -> AnyPublisher<[Track], Error> {
		return Future([]).eraseToAnyPublisher()
	}
}
