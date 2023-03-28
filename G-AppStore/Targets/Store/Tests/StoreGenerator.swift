@testable import Store
import CommonUI
import Foundation
import Combine

struct StoreViewModelGenrator {
	func callAsFunction(
		coordinator: StoreCoordinator,
		trackRepository: trackRepository,
		searchedTermRepository: SearchedTermRepository
	) -> StoreViewModel {
		let dependencies = StubStoreDependencies(
			trackRepository: trackRepository,
			searchedTermRepository: searchedTermRepository
		)
		return .init(coordinator: coordinator, dependencies: dependencies)
	}
}

struct StoreOutputGenerator {
	func callAsFunction(
		lifeCycle: CurrentValueSubject<ViewControllerLifeCycle, Never>,
		didSelectItem: PassthroughSubject<StoreSearchSection, Never>,
		viewModel: inout StoreViewModel
	) -> StoreOutput {
		let input = StoreInput(
			lifeCycle: lifeCycle.eraseToAnyPublisher(),
			didSelectItem: didSelectItem.eraseToAnyPublisher()
		)
		return viewModel.transform(input)
	}
}

struct SearchBarOutputGenerator {
	func callAsFunction(
		termSubject: PassthroughSubject<String, Never>,
		searchButtonTappedSubject: PassthroughSubject<String, Never>,
		searchCancelButtonTappedSubject: PassthroughSubject<Void, Never>,
		viewModel: inout StoreViewModel
	) -> SearchBarOutput {
		let input = SearchBarInput(
			term: termSubject.eraseToAnyPublisher(),
			searchButtonTapped: searchButtonTappedSubject.eraseToAnyPublisher(),
			searchCancelButtonTapped: searchCancelButtonTappedSubject.eraseToAnyPublisher()
		)
		return viewModel.transform(input)
	}
}

final class EntityGenerator {
	func callAsFunction<Entity: Decodable>(_ fileName: String, fileType: String) -> Entity? {
		guard let path = Bundle(for: type(of: self)).path(forResource: fileName, ofType: fileType) else {
			print("resource url is nil")
			return nil
		}
		do {
			let data: Data = try Data(contentsOf: URL(fileURLWithPath: path))
			let entity: Entity = try JSONDecoder().decode(Entity.self, from: data)
			return entity
		} catch {
			print(error)
			return nil
		}
	}
}
