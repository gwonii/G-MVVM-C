@testable import Store
import Combine

final class StubOneTrackRepository: trackRepository {
	private let generator: EntityGenerator = .init()
	
	func getTrackSearchResult(term: String) -> AnyPublisher<[Track], Error> {
		let result: ItunesResult! = generator("ItunesMockData", fileType: "json")
		return Future([
			.init(from: result)
		]).eraseToAnyPublisher()
	}
}
