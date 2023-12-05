//
//  BupNewsfeedMainView.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/11/28.
//

import UIKit
import Kingfisher

final class BupNewsfeedMainView: BaseView {
    var dataSource: UICollectionViewDiffableDataSource<BupContainer, BupContent>!

    lazy var collectionView = {
        let view = UICollectionView(
            frame: .zero,
            collectionViewLayout: createLayout()
        )
        return view
    }()

    override func initialHierarchy() {
        super.initialHierarchy()

        addSubview(collectionView)
    }

    override func initialLayout() {
        super.initialLayout()

        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }

}

private extension BupNewsfeedMainView {

    func createLayout() -> UICollectionViewLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 16

        let layout = UICollectionViewCompositionalLayout(
            sectionProvider: { [weak self] _, _ in
                guard let self else {return nil}
                return self.todoLayout()
            }, configuration: config
        )

        return layout
    }

    func todoLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(50)
        )

        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(50)
        )

        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )

        let headerFooterSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(80)
        )

        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerFooterSize,
            elementKind: BupNewsfeedHeader.identifier,
            alignment: .top
        )

        let footer = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerFooterSize,
            elementKind: BupNewsfeedFooter.identifier,
            alignment: .bottom
        )

        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [header, footer]
        section.interGroupSpacing = 1
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 1,
            leading: 16,
            bottom: 1,
            trailing: 16
        )

        return section
    }

}
