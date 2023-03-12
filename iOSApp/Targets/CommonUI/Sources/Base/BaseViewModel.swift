import UIKit
import Combine
import Common

open class BaseViewModel<Input: BaseInput, Output: BaseOutput, Coordinator: BaseCoordinator>: NSObject {
	public typealias Input = Input
	public typealias Output = Output

	public weak var coordinator: Coordinator?

	private let _isBusyPublisher: CurrentValueSubject<Bool, Never> = .init(false)
	public var isBusyPublisher: Publisher<Bool, Never> { return _isBusyPublisher.eraseToAnyPublisher() }
	public var isBusy: Bool { _isBusyPublisher.value }

	public init(coordinator: Coordinator) {
		self.coordinator = coordinator
		super.init()
	}

	open func transform(_ input: Input) -> Result<Output, Error> {
		return .failure(UICommonError.transformOutputError)
	}

	public func setBusy(_ isBusy: Bool) {
		_isBusyPublisher.send(isBusy)
	}
}
