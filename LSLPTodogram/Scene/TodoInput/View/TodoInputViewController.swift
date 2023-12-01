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


    private let viewModel: TodoInputViewModel

    init(_ viewModel: TodoInputViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        let todoAddButtonTapped = PublishRelay<Void>()

        let input = TodoInputViewModel.Input(
            todoAddButtonTapped: todoAddButtonTapped,
            itemDeleted: mainView.tableView.rx.itemDeleted
        )
        let output = viewModel.transform(input: input)

        let dataSource = RxTableViewSectionedReloadDataSource<TodoInputSection>(
            configureCell: { dataSource, tableView, indexPath, item in
                switch item {
                case .todoInfo(let todoInfo):
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: TodoInfoInputCell.identifier, for: indexPath) as? TodoInfoInputCell else {
                        return UITableViewCell()
                    }

                    cell.profileImageView.image = todoInfo.profileImage
                    cell.nicknameLabel.text = todoInfo.nickname

                    cell.titleTextView.rx.text.orEmpty
                        .bind(with: self) { owner, text in
                            UIView.setAnimationsEnabled(false)
                            tableView.beginUpdates()
                            tableView.endUpdates()
                            UIView.setAnimationsEnabled(true)
                        }
                        .disposed(by: cell.disposeBag)

                    return cell

                case .todo(let todo):
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: TodoInputCell.identifier, for: indexPath) as? TodoInputCell else {
                        return UITableViewCell()
                    }

                    cell.todoInputTextView.text = todo.title

                    cell.todoInputTextView.rx.text.orEmpty
                        .bind(with: self) { owner, text in
                            UIView.setAnimationsEnabled(false)
                            tableView.beginUpdates()
                            tableView.endUpdates()
                            UIView.setAnimationsEnabled(true)
                        }
                        .disposed(by: cell.disposeBag)

                    return cell

                case .todoAdd:
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: TodoAddCell.identifier, for: indexPath) as? TodoAddCell else {
                        return UITableViewCell()
                    }

                    cell.todoAddButton.rx.tap
                        .bind(with: self) { owner, void in
                            todoAddButtonTapped.accept(void)
                        }
                        .disposed(by: cell.disposeBag)

                    return cell
                }
            })

        dataSource.canEditRowAtIndexPath = { dataSource, indexPath in
            let section = dataSource.sectionModels[indexPath.section]
            if let test = section.items.first {
                switch test {
                case .todoInfo, .todoAdd:
                    return false
                case .todo:
                    return true
                }
            }
            return false
        }

        output.todoInputSectionList
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
