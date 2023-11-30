//
//  TodoNewsfeedViewController.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/11/28.
//

import UIKit
import RxCocoa
import RxSwift

final class TodoNewsfeedViewController: BaseViewController {
    private let mainView = TodoNewsfeedMainView()
    private let disposeBag = DisposeBag()

    init(_ viewModel: TodoNewsfeedViewModel) {
        super.init(nibName: nil, bundle: nil)

        let cellRegistration = UICollectionView.CellRegistration<TodoNewsfeedCell, Todo> { cell, indexPath, itemIdentifier in
            cell.todoLabel.text = "\(itemIdentifier.title)"
        }

        let headerRegistration = UICollectionView.SupplementaryRegistration<TodoNewsfeedHeader>(
            elementKind: TodoNewsfeedHeader.identifier
        ) { (supplementaryView, elementKind, indexPath) in
            let todoInfo = viewModel.todoInfoList.value[indexPath.item]
            supplementaryView.profileImageView.image = todoInfo.profileImage
            supplementaryView.nicknameLabel.text = todoInfo.nickname
            supplementaryView.titleLabel.text = todoInfo.title
        }

        let footerRegistration = UICollectionView.SupplementaryRegistration<TodoNewsfeedFooter>(
            elementKind: TodoNewsfeedFooter.identifier
        ) { (supplementaryView, elementKind, indexPath) in
            let todoInfo = viewModel.todoInfoList.value[indexPath.item]
//            let todoInfo = viewModel.todoInfoList.value[indexPath.item]
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
            if kind == TodoNewsfeedHeader.identifier {
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

        let input = TodoNewsfeedViewModel.Input()
        let output = viewModel.transform(input: input)

        output.todoInfoList
            .bind(with: self) { owner, todoInfoList in
                var snapshot = NSDiffableDataSourceSnapshot<TodoInfo, Todo>()
                snapshot.appendSections(todoInfoList)
                for todoInfo in todoInfoList {
                    snapshot.appendItems(todoInfo.todoList, toSection: todoInfo)
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
