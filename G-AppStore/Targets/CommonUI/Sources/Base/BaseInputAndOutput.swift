import Combine

public protocol BaseInput {}

public protocol BaseOutput {
	var cancellables: Set<AnyCancellable> { get }
}
