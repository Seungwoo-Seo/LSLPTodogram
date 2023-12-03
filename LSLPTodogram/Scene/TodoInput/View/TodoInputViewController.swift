//
//  TodoInputViewController.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/11/30.
//

import UIKit
import RxCocoa
import RxDataSources
import RxSwift

final class TodoInputViewController: BaseViewController {
    private let mainView = TodoInputMainView()
    private let disposeBag = DisposeBag()

    init(_ viewModel: TodoInputViewModel) {
        super.init(nibName: nil, bundle: nil)

        let todoAddButtonTapped = PublishRelay<Void>()
        let titleChanged = PublishRelay<(title: String, row: Int)>()

        let dataSource = RxTableViewSectionedReloadDataSource<TodoInputSection>(
            configureCell: { dataSource, tableView, indexPath, item in
                switch item {
                case .todoInfo(let todoInfo):
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: TodoInfoInputCell.identifier, for: indexPath) as? TodoInfoInputCell else {
                        return UITableViewCell()
                    }

                    cell.profileImageView.image = todoInfo.profileImage
                    cell.nicknameLabel.text = todoInfo.nickname
                    cell.titleTextView.text = todoInfo.title

                    cell.titleTextView.rx.didChange
                        .bind(with: self) { owner, _ in
                            UIView.setAnimationsEnabled(false)
                            tableView.beginUpdates()
                            tableView.endUpdates()
                            UIView.setAnimationsEnabled(true)
                        }
                        .disposed(by: cell.disposeBag)

                    cell.titleTextView.rx.didEndEditing
                        .withLatestFrom(cell.titleTextView.rx.text.orEmpty)
                        .bind(with: self) { owner, text in
                            titleChanged.accept((text, indexPath.row))
                        }
                        .disposed(by: cell.disposeBag)

                    return cell

                case .todo(let todo):
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: TodoInputCell.identifier, for: indexPath) as? TodoInputCell else {
                        return UITableViewCell()
                    }

                    cell.todoInputTextView.text = todo.title

                    cell.todoInputTextView.rx.didChange
                        .bind(with: self) { owner, _ in
                            UIView.setAnimationsEnabled(false)
                            tableView.beginUpdates()
                            tableView.endUpdates()
                            UIView.setAnimationsEnabled(true)
                        }
                        .disposed(by: cell.disposeBag)

                    cell.todoInputTextView.rx.didEndEditing
                        .withLatestFrom(cell.todoInputTextView.rx.text.orEmpty)
                        .bind(with: self) { owner, text in
                            titleChanged.accept((text, indexPath.row))
                        }
                        .disposed(by: cell.disposeBag)

                    return cell

                case .todoAdd:
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: TodoAddCell.identifier, for: indexPath) as? TodoAddCell else {
                        return UITableViewCell()
                    }

                    cell.todoAddButton.rx.tap
                        .bind(with: self) { owner, void in
                            owner.view.endEditing(true) // 필수
                            todoAddButtonTapped.accept(void)
                        }
                        .disposed(by: cell.disposeBag)

                    return cell
                }
            })

        dataSource.canEditRowAtIndexPath = { dataSource, indexPath in
            let section = dataSource.sectionModels[indexPath.section]

            if indexPath.row == 0 || section.items.count - 1 == indexPath.row {
                return false
            }

            return true
        }

        let input = TodoInputViewModel.Input(
            titleChanged: titleChanged,
            todoAddButtonTapped: todoAddButtonTapped,
            itemDeleted: mainView.tableView.rx.itemDeleted
        )
        let output = viewModel.transform(input: input)

        output.sections
            .bind(to: mainView.tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }

    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func initialAttributes() {
        super.initialAttributes()

        navigationItem.title = "새로운 Todo"
    }

}
