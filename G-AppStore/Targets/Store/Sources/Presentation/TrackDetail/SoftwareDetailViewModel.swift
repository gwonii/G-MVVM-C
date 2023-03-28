import Combine
import CommonUI

final class TrackDetailViewModel: BaseViewModel<
TrackDetailInput,
TrackDetailOutput
> {
	init(track: Track) {
		self.track = track
	}
	
	@Published
	private var track: Track?
	
	override func transform(_ input: Input) -> Output {
		let output: Output = .init(
			cancellables: .init(),
			track: $track
				.compactMap({ $0 })
				.eraseToAnyPublisher()
		)
		return output
	}
}
