import Combine
import CommonData

final class DefaultTrackRepository: trackRepository {
	func getTrackSearchResult(term: String) -> AnyPublisher<[Track], Error> {
		let response: AnyPublisher<ItunesResponse, Error> = StoreAPI
			.getTracks(term: term)
			.request()
			.eraseToAnyPublisher()
		
		return response
			.map(\.results)
			.map({ (results) in
				return results.map({ $0.map({ Track(from: $0) }) }) ?? []
			})
			.eraseToAnyPublisher()
	}
}
