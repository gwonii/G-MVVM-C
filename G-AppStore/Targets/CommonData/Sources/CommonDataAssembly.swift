import Foundation
import Swinject
import Alamofire
import DIContainer

public final class CommonDataAssembly: Assembly {
	public init() {}
	
	public func assemble(container: Container) {
		container.register(Session.self) { _ in
			let configuration: URLSessionConfiguration = URLSessionConfiguration.af.default
			configuration.timeoutIntervalForRequest = 30
			let session: Session = .init(
				configuration: configuration,
				interceptor: RetryPolicy.init(retryLimit: 3)
			)
			return session
		}.inObjectScope(.container)
	}
}
