import Combine
import CommonUI

struct SearchBarInput: BaseInput {
	let term: AnyPublisher<String, Never>
	let searchButtonTapped: AnyPublisher<String, Never>
	let searchCancelButtonTapped: AnyPublisher<Void, Never>
}

struct SearchBarOutput: BaseOutput {
	let cancellables: Set<AnyCancellable>
}
