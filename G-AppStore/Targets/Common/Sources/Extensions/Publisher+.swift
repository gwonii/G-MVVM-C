import Combine

public extension Publisher where Self.Failure == Never {
	func assignNoRetain<Root>(to keyPath: ReferenceWritableKeyPath<Root, Self.Output>, on object: Root) -> AnyCancellable where Root: AnyObject {
		sink { [weak object] (value) in
			object?[keyPath: keyPath] = value
		}
	}
}
