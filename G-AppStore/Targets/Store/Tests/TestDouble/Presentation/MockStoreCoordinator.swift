@testable import Store
import CommonUI


final class MockStoreCoordinator: StoreCoordinator {
	let childCoordinators: [Coordinator] = []
	let type: CommonUI.CoordinatorType = .storeHomeList
	
	var presenttrackDetailViewDidCalledCount: Int = 0
	
	func presenttrackDetailView(track: Track) {
		print("presenttrackDetailView")
		presenttrackDetailViewDidCalledCount += 1
	}
}
