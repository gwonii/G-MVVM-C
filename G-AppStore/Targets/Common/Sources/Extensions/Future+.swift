import Combine

public extension Future where Failure == Error {
	convenience init(_ error: Error) {
		self.init { (promiss) in
			promiss(.failure(error))
		}
	}
}

public extension Future where Failure == Error {
	convenience init(_ output: Output) {
		self.init { (promiss) in
			promiss(.success(output))
		}
	}
}

public extension Future where Failure == Never {
	convenience init(_ output: Output) {
		self.init { (promiss) in
			promiss(.success(output))
		}
	}
}
