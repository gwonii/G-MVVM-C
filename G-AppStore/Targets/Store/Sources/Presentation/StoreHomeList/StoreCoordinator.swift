import CommonUI

protocol StoreCoordinator: Coordinator {
	func presenttrackDetailView(track: Track)
}

final class DefaultStoreCoordinator: BaseCoordinator, StoreCoordinator {
	func presenttrackDetailView(track: Track) {
		let viewModel: TrackDetailViewModel = .init(track: track)
		let viewController: TrackDetailViewController = .init(viewModel: viewModel)
		navigationController.navigationBar.prefersLargeTitles = false
		push(viewController)
	}
}
