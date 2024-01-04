//
//  BupInputViewController.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/11/30.
//

import UIKit
import RxCocoa
import RxSwift

final class BupInputViewController: BaseViewController {
    private let postingButton = {
        let barButtonItem = UIBarButtonItem()
        barButtonItem.title = "게시"
        barButtonItem.style = .plain
        return barButtonItem
    }()
    private let mainView = BupInputMainView()
    private var disposeBag = DisposeBag()

    private let viewModel: BupInputViewModel   // 메모리 때문에 작성

    init(_ viewModel: BupInputViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        let title = PublishRelay<(title: String, row: Int)>()
        let content = PublishRelay<(content: String, row: Int)>()
        let bupAddButtonTapped = PublishRelay<Void>()
        let postingButtonTapped = PublishRelay<Void>()

        mainView.tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)

        postingButton.rx.tap
            .bind(with: self) { owner, void in
                owner.view.endEditing(true)
                print("✅", "체크")
                postingButtonTapped.accept(void)
            }
            .disposed(by: disposeBag)
        
        let input = BupInputViewModel.Input(
            title: title,
            content: content,
            bupAddButtonTapped: bupAddButtonTapped,
            itemDeleted: mainView.tableView.rx.itemDeleted,
            postingButtonTapped: postingButtonTapped
        )
        let output = viewModel.transform(input: input)

        output.items
            .bind(to: mainView.tableView.rx.items) { tableView, row, item in
                switch item {
                case .info(let item):
                    let cell = tableView.dequeueReusableCell(
                        withIdentifier: BupInfoInputCell.identifier
                    ) as! BupInfoInputCell

                    cell.configure(item)
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
                            title.accept((text, row))
                        }
                        .disposed(by: cell.disposeBag)

                    return cell

                case .content(let item):
                    let cell = tableView.dequeueReusableCell(
                        withIdentifier: BupContentInputCell.identifier
                    ) as! BupContentInputCell

                    cell.configure(item)
                    cell.bupContentInputTextView.rx.didChange
                        .bind(with: self) { owner, _ in
                            UIView.setAnimationsEnabled(false)
                            tableView.beginUpdates()
                            tableView.endUpdates()
                            UIView.setAnimationsEnabled(true)
                        }
                        .disposed(by: cell.disposeBag)

                    cell.bupContentInputTextView.rx.didEndEditing
                        .withLatestFrom(cell.bupContentInputTextView.rx.text.orEmpty)
                        .bind(with: self) { owner, text in
                            content.accept((text, row))
                        }
                        .disposed(by: cell.disposeBag)

                    return cell

                case .add:
                    let cell = tableView.dequeueReusableCell(
                        withIdentifier: BupContentAddCell.identifier
                    ) as! BupContentAddCell

                    cell.bupAddButton.rx.tap
                        .bind(with: self) { owner, void in
                            owner.view.endEditing(true) // 필수
                            bupAddButtonTapped.accept(void)
                        }
                        .disposed(by: cell.disposeBag)

                    return cell
                }
            }
            .disposed(by: disposeBag)

        output.postingDone
            .bind(with: self) { owner, _ in
                owner.unwind()
            }
            .disposed(by: disposeBag)
    }

    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        disposeBag = DisposeBag()
    }

    override func initialAttributes() {
        super.initialAttributes()

        navigationItem.title = "새로운 Todo"
        navigationItem.rightBarButtonItem = postingButton
    }

}

extension BupInputViewController: UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        editingStyleForRowAt indexPath: IndexPath
    ) -> UITableViewCell.EditingStyle {
        switch indexPath.row {
        case 1, 2, 3: return .delete
        default: return .none
        }
    }

}

private extension BupInputViewController {

    func unwind() {
        dismiss(animated: true)
    }

}
