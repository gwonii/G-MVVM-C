import struct UIKit.IndexPath
import class UIKit.UICollectionViewCell
import class UIKit.UICollectionView
import CommonUI

struct StoreSearchSection: Hashable {
	init(
		kindsOfSection: StoreSearchKindsOfSection,
		items: [StoreSearchKindsOfItem]
	) {
		self.kindsOfSection = kindsOfSection
		self.items = items
	}
	
	let kindsOfSection: StoreSearchKindsOfSection
	let items: [StoreSearchKindsOfItem]
}

enum StoreSearchKindsOfSection: Hashable {
	case recentlySearch
	case autoCompletion
	case track
	
	var emptyMessage: String {
		switch self {
			case .recentlySearch:
				return "최근 검색 결과가 없습니다."
			case .autoCompletion:
				return "연관된 키워드가 없습니다."
			case .track:
				return "검색 결과가 없습니다."
		}
	}
}

enum StoreSearchKindsOfItem: Hashable {
	case recentlySearch(term: String)
	case autoCompletion(term: String)
	case track(track: Track)
	case emptyView(message: String)
	
	var cellType: any CellType.Type {
		switch self {
			case .recentlySearch:
				return StoreSearchCollectionRecentlySearchCell.self
			case .autoCompletion:
				return StoreSearchCollectionAutoCompletionCell.self
			case .track:
				return StoreSearchCollectionTrackCell.self
			case .emptyView:
				return StoreSearchEmptyViewCell.self
		}
	}
}

extension StoreSearchKindsOfItem {
	func makeCollectionViewCell(
		target collectionView: inout UICollectionView,
		indexPath: IndexPath,
		from item: StoreSearchKindsOfItem
	) -> UICollectionViewCell? {
		switch self {
			case .recentlySearch(let term):
				guard let cell = collectionView.dequeueReusableCell(
					withReuseIdentifier: item.cellType.reuseIdentifier,
					for: indexPath
				) as? StoreSearchCollectionRecentlySearchCell else {
					return .init()
				}
				cell.setup(term)
				return cell
			case .autoCompletion(let term):
				guard let cell = collectionView.dequeueReusableCell(
					withReuseIdentifier: item.cellType.reuseIdentifier,
					for: indexPath
				) as? StoreSearchCollectionAutoCompletionCell else {
					return .init()
				}
				cell.setup(term)
				return cell
			case .track(let track):
				guard let cell = collectionView.dequeueReusableCell(
					withReuseIdentifier: item.cellType.reuseIdentifier,
					for: indexPath
				) as? StoreSearchCollectionTrackCell else {
					return .init()
				}
				cell.setup(track)
				return cell
			case .emptyView(let message):
				guard let cell = collectionView.dequeueReusableCell(
					withReuseIdentifier: item.cellType.reuseIdentifier,
					for: indexPath
				) as? StoreSearchEmptyViewCell else {
					return .init()
				}
				cell.setup(message)
				return cell
		}
	}
}
