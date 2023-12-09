//
//  BupView.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/07.
//

import UIKit

final class BupView: BaseView {
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

    func configureDataSource<T: BupViewModelType>(_ viewModel: T) where T: AnyObject {
        let cellRegistration = UICollectionView.CellRegistration<BupCell, BupContent> { cell, indexPath, itemIdentifier in
            cell.configure(itemIdentifier)
        }

        let headerRegistration = UICollectionView.SupplementaryRegistration<BupHeader>(
            elementKind: BupHeader.identifier
        ) { [unowned viewModel] (supplementaryView, elementKind, indexPath) in
            let bupTop = viewModel.bupContainerList.value[indexPath.section].bupTop
            supplementaryView.configure(bupTop)
        }

        let footerRegistration = UICollectionView.SupplementaryRegistration<BupFooter>(
            elementKind: BupFooter.identifier
        ) { [unowned viewModel] (supplementaryView, elementKind, indexPath) in
            let bupBottom = viewModel.bupContainerList.value[indexPath.section].bupBottom
            supplementaryView.configure(bupBottom)
        }

        dataSource = UICollectionViewDiffableDataSource(
            collectionView: collectionView
        ) { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: itemIdentifier
            )
        }

        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            if kind == BupHeader.identifier {
                return collectionView.dequeueConfiguredReusableSupplementary(
                    using: headerRegistration,
                    for: indexPath
                )
            } else {
                return collectionView.dequeueConfiguredReusableSupplementary(
                    using: footerRegistration,
                    for: indexPath
                )
            }
        }
    }

}

private extension BupView {

    func createLayout() -> UICollectionViewLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 16

        let layout = UICollectionViewCompositionalLayout(
            sectionProvider: { [weak self] _, _ in
                guard let self else {return nil}
                return self.bupSection()
            }, configuration: config
        )

        return layout
    }

    func bupSection() -> NSCollectionLayoutSection {
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
            elementKind: BupHeader.identifier,
            alignment: .top
        )

        let footer = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerFooterSize,
            elementKind: BupFooter.identifier,
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
