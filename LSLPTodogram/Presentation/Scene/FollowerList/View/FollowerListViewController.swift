//
//  FollowerListViewController.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2024/01/09.
//

import UIKit
import RxCocoa
import RxSwift

final class FollowerListViewController: BaseViewController {
    private let disposeBag = DisposeBag()

    private lazy var cancelBarButtonItem = {
        let barButtonItem = UIBarButtonItem(
            title: "취소", style: .plain, target: self, action: #selector(didTapCancelBarButtonItem)
        )
        return barButtonItem
    }()
    @objc private func didTapCancelBarButtonItem() {
        dismiss(animated: true)
    }

    private let mainView = FollowerListMainView()

    private let viewModel: FollowerListViewModel

    init(_ viewModel: FollowerListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        let viewDidLoad = rx.sentMessage(#selector(UIViewController.viewDidLoad))
            .map { _ in Void() }
//        let pull = mainView.tableView.refreshControl!.rx.controlEvent(.valueChanged).asObservable()

        let input = FollowerListViewModel.Input(
            trigger: Observable.merge(viewDidLoad)
        )
        let output = viewModel.transform(input: input)
        output.items
            .drive(mainView.tableView.rx.items) { tv, row, item in
                guard let cell = tv.dequeueReusableCell(
                    withIdentifier: FollowerListCell.identifier
                ) as? FollowerListCell else {return UITableViewCell()}

                cell.configure(item)

                return cell
            }
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

        navigationController?.navigationBar.tintColor = Color.white
        navigationItem.title = "팔로워"
        navigationItem.leftBarButtonItem = cancelBarButtonItem
    }
}
