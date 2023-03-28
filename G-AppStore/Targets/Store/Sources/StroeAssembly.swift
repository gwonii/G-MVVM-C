import CommonUI
import Swinject
import DIContainer

public final class StoreAssembly: Assembly {
	public init() {}
	
	public func assemble(container: Container) {
		container.register(trackRepository.self) { _ in
			return DefaultTrackRepository()
		}.inObjectScope(.container)
		
		container.register(SearchedTermRepository.self) { _ in
			return DefaultSearchedTermRepository(store: get())
		}.inObjectScope(.container)
		
		container.register(StoreDependencies.self) { _ in
			return DefaultStoreDependencies(get(), get())
		}.inObjectScope(.container)
		
		container.register(ViewContainer.self, name: CoordinatorType.storeHomeList.rawValue) { _ in
			let coordinator: StoreCoordinator = DefaultStoreCoordinator(get("main"), type: .storeHomeList)
			let dependencies: StoreDependencies = get()
			let viewModel: StoreViewModel = .init(
				coordinator: coordinator,
				dependencies: dependencies
			)
			let viewController: StoreViewController = .init(viewModel: viewModel)
			return .init(
				viewController: viewController,
				coordinator: coordinator
			)
		}
	}
}
