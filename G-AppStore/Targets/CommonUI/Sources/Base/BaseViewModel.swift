import class UIKit.NSObject
import Combine
import Common

open class BaseViewModel<Input: BaseInput, Output: BaseOutput>: NSObject {
	public typealias Input = Input
	public typealias Output = Output

	private let _isBusyPublisher: CurrentValueSubject<Bool, Never> = .init(false)
	public var isBusyPublisher: AnyPublisher<Bool, Never> { return _isBusyPublisher.eraseToAnyPublisher() }

	open func transform(_ input: Input) -> Output {
		fatalError("should override method")
	}

	public func setBusy(_ isBusy: Bool) {
		_isBusyPublisher.send(isBusy)
	}
}
