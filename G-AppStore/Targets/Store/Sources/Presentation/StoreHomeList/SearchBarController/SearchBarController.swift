import protocol UIKit.UISearchResultsUpdating
import protocol UIKit.UISearchBarDelegate
import class UIKit.UISearchController
import class UIKit.UISearchController
import class UIKit.NSCoder
import class UIKit.UISearchBar
import Combine
import CommonUI

final class SearchBarController: UISearchController {
	typealias Input = SearchBarInput
	typealias Output = SearchBarOutput
	
	init() {
		super.init(nibName: nil, bundle: nil)
		searchResultsUpdater = self
		searchBar.delegate = self
		searchBar.placeholder = "게임, 앱, 스토리 등"
		hidesNavigationBarDuringPresentation = true
	}
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private var isInitializedTerm: Bool = false
	
	private let termSubject: CurrentValueSubject<String, Never> = .init("")
	private let searchButtonTapSubject: PassthroughSubject<String, Never> = .init()
	private var searchButtonTapPublisher: AnyPublisher<String, Never> {
		return searchButtonTapSubject
			.eraseToAnyPublisher()
		
	}
	private let searchCancelButtonTapSubject: PassthroughSubject<Void, Never> = .init()
	private var searchCancelButtonTapPublisher: AnyPublisher<Void, Never> {
		return searchCancelButtonTapSubject.eraseToAnyPublisher()
	}
	
	func makeInput() -> Input {
		return .init(
			term: termSubject
				.drop(while: { $0.isEmpty })
				.eraseToAnyPublisher(),
			searchButtonTapped: searchButtonTapPublisher,
			searchCancelButtonTapped: searchCancelButtonTapPublisher
		)
	}
}

extension SearchBarController: UISearchResultsUpdating, UISearchBarDelegate {
	func updateSearchResults(for searchController: UISearchController) {
		guard let term = searchController.searchBar.text,
			  isInitializedTerm == false
		else {
			return
		}
		termSubject.send(term)
	}
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		guard let text = searchBar.text else {
			return
		}
		searchButtonTapSubject.send(text)
	}
	
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		isInitializedTerm = true
		searchCancelButtonTapSubject.send(())
	}
	
	func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
		isInitializedTerm = false
		return true
	}
}
