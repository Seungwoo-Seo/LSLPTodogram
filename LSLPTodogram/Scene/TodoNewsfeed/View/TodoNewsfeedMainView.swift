//
//  TodoNewsfeedMainView.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/11/28.
//

import UIKit
import Kingfisher

final class TodoNewsfeedMainView: BaseView {
    var dataSource: UICollectionViewDiffableDataSource<TodoInfo, Todo>!

    lazy var collectionView = {
        let view = UICollectionView(
            frame: .zero,
            collectionViewLayout: createLayout()
        )
        view.backgroundColor = Color.lightGray
        return view
    }()

    override func initialAttributes() {
        super.initialAttributes()

//        configureDataSource()
    }

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

private extension TodoNewsfeedMainView {

    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (_, _) in
            guard let self else {return nil}
            return self.todoLayout()
        }

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

        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(80)
        )

        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: TodoNewsfeedHeader.identifier,
            alignment: .top
        )

        let footerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(80)
        )

        let footer = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerSize,
            elementKind: TodoNewsfeedFooter.identifier,
            alignment: .bottom
        )

        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [header, footer]

        return section
    }

}
