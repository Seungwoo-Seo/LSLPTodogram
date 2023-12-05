//
//  BupNewsfeedViewController.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/11/28.
//

import UIKit
import RxCocoa
import RxSwift

final class BupNewsfeedViewController: BaseViewController {
    private let mainView = BupNewsfeedMainView()
    private let disposeBag = DisposeBag()

    init(_ viewModel: BupNewsfeedViewModel) {
        super.init(nibName: nil, bundle: nil)

        let cellRegistration = UICollectionView.CellRegistration<BupNewsfeedCell, BupContent> { cell, indexPath, itemIdentifier in
            cell.bupContentLabel.text = itemIdentifier.content
        }

        let headerRegistration = UICollectionView.SupplementaryRegistration<BupNewsfeedHeader>(
            elementKind: BupNewsfeedHeader.identifier
        ) { (supplementaryView, elementKind, indexPath) in
            let bupTop = viewModel.bupContainerList.value[indexPath.section].bupTop
            supplementaryView.profileImageView.image = UIImage(systemName: "person")
            supplementaryView.nicknameLabel.text = bupTop.nick
            supplementaryView.phoneNumLabel.text = "핸드폰: 미설정"
            supplementaryView.titleLabel.text = bupTop.title
        }

        let footerRegistration = UICollectionView.SupplementaryRegistration<BupNewsfeedFooter>(
            elementKind: BupNewsfeedFooter.identifier
        ) { (supplementaryView, elementKind, indexPath) in
            let bupBottom = viewModel.bupContainerList.value[indexPath.section].bupBottom
        }

        mainView.dataSource = UICollectionViewDiffableDataSource(
            collectionView: mainView.collectionView
        ) { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: itemIdentifier
            )
        }

        mainView.dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            if kind == BupNewsfeedHeader.identifier {
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

        let input = BupNewsfeedViewModel.Input(
            prefetchItems: mainView.collectionView.rx.prefetchItems
        )
        let output = viewModel.transform(input: input)

        output.bupContainerList
            .bind(with: self) { owner, bupContainerList in
                var snapshot = NSDiffableDataSourceSnapshot<BupContainer, BupContent>()
                snapshot.appendSections(bupContainerList)
                for bupContainer in bupContainerList {
                    snapshot.appendItems(bupContainer.bupContents, toSection: bupContainer)
                }
                owner.mainView.dataSource.apply(snapshot)
            }
            .disposed(by: disposeBag)
    }

    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}
