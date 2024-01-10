//
//  EllipsisViewController.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2024/01/09.
//

import UIKit
import RxCocoa
import RxSwift
import PanModal

final class EllipsisViewController: BaseViewController {
    private let disposeBag = DisposeBag()

    private let mainView = EllipsisMainView()

    private let viewModel: EllipsisViewModel

    init(_ viewModel: EllipsisViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        let viewDidLoad = rx.sentMessage(#selector(UIViewController.viewDidLoad))
            .map { _ in Void() }
            .asObservable()

        let input = EllipsisViewModel.Input(
            trigger: viewDidLoad,
            modelSelected: mainView.tableView.rx.modelSelected(String.self)
        )
        let output = viewModel.transform(input: input)
        output.items
            .drive(mainView.tableView.rx.items) { tv, row, item in
                guard let cell = tv.dequeueReusableCell(
                    withIdentifier: EllipsisCell.identifier
                ) as? EllipsisCell else {return UITableViewCell()}

                cell.configure(item)

                return cell
            }
            .disposed(by: disposeBag)

        mainView.tableView.rx.modelSelected(String.self)
            .bind(with: self) { owner, _ in
                owner.dismiss(animated: true)
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

extension EllipsisViewController: PanModalPresentable {

    var panScrollable: UIScrollView? {
        return nil
    }

    var shortFormHeight: PanModalHeight {
        return .contentHeight(80)
    }

    var longFormHeight: PanModalHeight {
        return .contentHeight(80)
    }

}
