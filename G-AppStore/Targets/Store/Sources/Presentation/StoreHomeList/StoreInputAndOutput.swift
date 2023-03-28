import Combine
import CommonUI

struct StoreInput: BaseInput {
	var lifeCycle: AnyPublisher<ViewControllerLifeCycle, Never>?
	var didSelectItem: AnyPublisher<StoreSearchSection, Never>
}

struct StoreOutput: BaseOutput {
	let cancellables: Set<AnyCancellable>
	let collectionViewSection: AnyPublisher<StoreSearchSection, Never>
}
