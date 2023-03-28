import Combine
import CommonUI

struct TrackDetailInput: BaseInput {}

struct TrackDetailOutput: BaseOutput {
	let cancellables: Set<AnyCancellable>
	let track: AnyPublisher<Track, Never>
}
