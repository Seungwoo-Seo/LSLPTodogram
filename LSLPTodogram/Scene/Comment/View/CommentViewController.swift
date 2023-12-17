//
//  CommentViewController.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/14.
//

import UIKit
import RxCocoa
import RxSwift

final class CommentViewController: BaseViewController {
    private var disposeBag = DisposeBag()

    private let cancelBarButtonItem = {
        let barButtonItem = UIBarButtonItem()
        barButtonItem.title = "취소"
        barButtonItem.style = .plain
        return barButtonItem
    }()
    private let postingBarButtonItem = {
        let barButtonItem = UIBarButtonItem()
        barButtonItem.title = "게시"
        barButtonItem.style = .plain
        return barButtonItem
    }()
    private let mainView = CommentMainView()

    private let viewModel: CommentViewModel // 메모리 때문에 선언

    init(_ viewModel: CommentViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        mainView.tableView.bind(viewModel.commentTableViewModel)

        let input = CommentViewModel.Input(
            cancelBarButtomItemTapped: cancelBarButtonItem.rx.tap,
            postingBarButtonItemTapped: postingBarButtonItem.rx.tap
        )
        let output = viewModel.transform(input: input)
        output.commentState
            .bind(to: self.rx.isModalInPresentation, postingBarButtonItem.rx.isEnabled)
            .disposed(by: disposeBag)

        output.cancelState
            .bind(with: self) { owner, bool in
                owner.unwind(bool)
            }
            .disposed(by: disposeBag)

        output.postingState
            .bind(with: self) { owner, result in
                switch result {
                case .success:
                    owner.unwind(false)
                case .failure:
                    print("ㅅㅂ")
                }
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

        navigationItem.title = "답글 달기"
    }

    override func initialHierarchy() {
        super.initialHierarchy()

        navigationItem.leftBarButtonItem = cancelBarButtonItem
        navigationItem.rightBarButtonItem = postingBarButtonItem
    }

}

private extension CommentViewController {

    func unwind(_ state: Bool) {
        if state {
            let alert = UIAlertController(
                title: "답글을 삭제하시겠어요?",
                message: nil,
                preferredStyle: .alert
            )

            let cancel = UIAlertAction(title: "취소", style: .cancel)
            let remove = UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
                guard let self else {return}
                self.dismiss(animated: true)
            }
            [cancel, remove].forEach { alert.addAction($0) }

            present(alert, animated: true)
        } else {
            dismiss(animated: true)
        }
    }

}
