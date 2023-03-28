import class UIKit.UICollectionViewLayout
import class UIKit.NSCollectionLayoutSection
import class UIKit.NSCollectionLayoutSize
import class UIKit.NSCollectionLayoutItem
import class UIKit.NSCollectionLayoutGroup
import class UIKit.NSCollectionLayoutBoundarySupplementaryItem
import class UIKit.UICollectionView

extension NSCollectionLayoutSection {
	static func getStoreCollectionLayoutSection(_ kindsOfSection: StoreSearchKindsOfSection) -> NSCollectionLayoutSection {
		switch kindsOfSection {
			case .recentlySearch:
				let itemSize: NSCollectionLayoutSize = .init(
					widthDimension: .fractionalWidth(1),
					heightDimension: .estimated(48)
				)
				let item: NSCollectionLayoutItem = .init(layoutSize: itemSize)
				
				let groupSize: NSCollectionLayoutSize = .init(
					widthDimension: .fractionalWidth(1),
					heightDimension: .estimated(48)
				)
				let group: NSCollectionLayoutGroup = .vertical(layoutSize: groupSize, subitems: [item])
				group.interItemSpacing = .fixed(2)
				
				let section: NSCollectionLayoutSection = .init(group: group)
				section.contentInsets = .init(top: 8, leading: 16, bottom: 8, trailing: 16)
				
				let sectionHeaderSize: NSCollectionLayoutSize = .init(
					widthDimension: .fractionalWidth(1),
					heightDimension: .absolute(16)
				)
				let sectionHeader: NSCollectionLayoutBoundarySupplementaryItem = .init(
					layoutSize: sectionHeaderSize,
					elementKind: UICollectionView.elementKindSectionHeader,
					alignment: .top
				)
				section.boundarySupplementaryItems = [sectionHeader]
				return section
			case .autoCompletion:
				let itemSize: NSCollectionLayoutSize = .init(
					widthDimension: .fractionalWidth(1),
					heightDimension: .estimated(48)
				)
				let item: NSCollectionLayoutItem = .init(layoutSize: itemSize)
				
				let groupSize: NSCollectionLayoutSize = .init(
					widthDimension: .fractionalWidth(1),
					heightDimension: .estimated(48)
				)
				let group: NSCollectionLayoutGroup = .vertical(layoutSize: groupSize, subitems: [item])
				group.interItemSpacing = .fixed(2)
				
				let section: NSCollectionLayoutSection = .init(group: group)
				section.contentInsets = .init(top: 8, leading: 16, bottom: 8, trailing: 16)
				
				return section
			case .track:
				let itemSize: NSCollectionLayoutSize = .init(
					widthDimension: .fractionalWidth(1),
					heightDimension: .estimated(280)
				)
				let item: NSCollectionLayoutItem = .init(layoutSize: itemSize)
				
				let groupSize: NSCollectionLayoutSize = .init(
					widthDimension: .fractionalWidth(1),
					heightDimension: .estimated(280)
				)
				let group: NSCollectionLayoutGroup = .vertical(layoutSize: groupSize, subitems: [item])
				
				let section: NSCollectionLayoutSection = .init(group: group)
				section.interGroupSpacing = 32
				
				section.contentInsets = .init(top: 8, leading: 16, bottom: 8, trailing: 16)
				
				return section
		}
	}
}
