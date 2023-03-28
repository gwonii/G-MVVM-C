import Foundation
import Swinject

public func get<T>(_ name: String? = nil) -> T {
	return container.synchronize().resolve(T.self, name: name)!
}

public func applyAssemblies(_ assemblies: [Assembly]) {
	let _: Assembler = .init(assemblies, container: container)
}

public let container: Container = .init()
