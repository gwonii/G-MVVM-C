import struct UIKit.CGFloat
import struct UIKit.NSDiffableDataSourceSnapshot
import class UIKit.NSCoder
import class UIKit.UICollectionViewDiffableDataSource
import class UIKit.UICollectionView
import class UIKit.UICollectionViewCompositionalLayout
import class UIKit.UICollectionViewCell
import class UIKit.UICollectionReusableView
import class UIKit.NSCollectionLayoutSection
import Combine
import CommonUI

final class StoreRootView: BaseRootView<StoreInput> {
	typealias DataSource = UICollectionViewDiffableDataSource<StoreSearchKindsOfSection, StoreSearchKindsOfItem>
	typealias Snapshot = NSDiffableDataSourceSnapshot<StoreSearchKindsOfSection, StoreSearchKindsOfItem>
	
	override init() {
		super.init()
		initView()
		registerCells()
	}
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	var collectionViewDidScrollPublisher: AnyPublisher<CGFloat, Never> {
		return collectionView.didScrollPublisher
			.compactMap({ [weak collectionView] _ -> CGFloat? in
				guard let collectionView else { return nil }
				return collectionView.contentOffset.y
			})
			.eraseToAnyPublisher()
	}
	
	private lazy var collectionView: UICollectionView = {
		let layout: UICollectionViewCompositionalLayout = getLayout()
		let collectionView: UICollectionView = .init(frame: .zero, collectionViewLayout: layout)
		return collectionView
	}()
	
	private var didSelectItem: AnyPublisher<StoreSearchSection, Never>  {
		return collectionView
			.didSelectItem
			.compactMap({ [weak self] (indexPath) -> StoreSearchSection? in
				guard let self,
					  let kindsOfSection = self.dataSource.snapshot().sectionIdentifiers[safe: indexPath.section],
					  let item = self.dataSource.snapshot(for: kindsOfSection).items[safe: indexPath.row]
				else {
					return nil
				}
				return .init(
					kindsOfSection: kindsOfSection,
					items: [item]
				)
			})
			.eraseToAnyPublisher()
	}
	
	private lazy var dataSource: DataSource! = {
		/// Set CollectionView Cell
		let dataSource: DataSource = .init(
			collectionView: collectionView,
			cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
				var collectionView = collectionView
				return item.makeCollectionViewCell(
					target: &collectionView,
					indexPath: indexPath,
					from: item
				)
			}
		)
		
		/// Set CollectionView Section Header
		dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) -> UICollectionReusableView? in
			guard
				let section: StoreSearchKindsOfSection = dataSource.snapshot().sectionIdentifiers[safe: indexPath.section],
				section == .recentlySearch,
				let sectionHeader: StoreSearchRecentlySearchSectionHeader = collectionView.dequeueReusableSupplementaryView(
				ofKind: UICollectionView.elementKindSectionHeader,
				withReuseIdentifier: StoreSearchRecentlySearchSectionHeader.reuseIdentifer,
				for: indexPath
			) as? StoreSearchRecentlySearchSectionHeader else {
				return nil
			}

			return sectionHeader
		}
		return dataSource
	}()
	
	func applySnapshot(_ section: StoreSearchSection) {
		var snapShot: Snapshot = .init()
		snapShot.appendSections([section.kindsOfSection])
		snapShot.appendItems(section.items, toSection: section.kindsOfSection)
		dataSource.apply(snapShot, animatingDifferences: true)
	}
	
	// MARK: public methods
	func makeInput() -> Input {
		return .init(didSelectItem: didSelectItem)
	}

	// MARK: private methods
	private func initView() {
		addSubview(collectionView)
		collectionView.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}
	}
	
	private func registerCells() {
		collectionView.register(
			StoreSearchCollectionRecentlySearchCell.self,
			forCellWithReuseIdentifier: StoreSearchCollectionRecentlySearchCell.reuseIdentifier
		)
		collectionView.register(
			StoreSearchCollectionAutoCompletionCell.self,
			forCellWithReuseIdentifier: StoreSearchCollectionAutoCompletionCell.reuseIdentifier
		)
		collectionView.register(
			StoreSearchCollectionTrackCell.self,
			forCellWithReuseIdentifier: StoreSearchCollectionTrackCell.reuseIdentifier
		)
		collectionView.register(
			StoreSearchEmptyViewCell.self,
			forCellWithReuseIdentifier: StoreSearchEmptyViewCell.reuseIdentifier
		)
		collectionView.register(
			StoreSearchRecentlySearchSectionHeader.self,
			forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
			withReuseIdentifier: StoreSearchRecentlySearchSectionHeader.reuseIdentifer
		)
	}
}

/// Compositional Layout
extension StoreRootView {
	func getLayout() -> UICollectionViewCompositionalLayout {
		return UICollectionViewCompositionalLayout { [weak self] (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
			guard let self = self,
				  let kindsOfSection: StoreSearchKindsOfSection = self.dataSource.snapshot().sectionIdentifiers[safe: sectionIndex]
			else { return nil }
			
			return .getStoreCollectionLayoutSection(kindsOfSection)
		}
	}
}
