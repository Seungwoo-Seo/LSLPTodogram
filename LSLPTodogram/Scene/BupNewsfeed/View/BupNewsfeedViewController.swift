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

        let rowOfLikebutton = PublishRelay<Int>()

        let input = BupNewsfeedViewModel.Input(
            prefetchRows: mainView.tableView.rx.prefetchRows,
            rowOfLikebutton: rowOfLikebutton
        )
        let output = viewModel.transform(input: input)

        output.items
            .bind(to: mainView.tableView.rx.items) { tv, row, item in
                guard let cell = tv.dequeueReusableCell(
                    withIdentifier: BupCell.identifier
                ) as? BupCell else {return UITableViewCell()}

                cell.configure(item)

                cell.bupView.communicationView.likeButton.rx.tap
                    .withLatestFrom(Observable.just(row))
                    .bind(to: rowOfLikebutton)
                    .disposed(by: cell.disposeBag)

                cell.bupView.communicationView.commentButton.rx.tap
                    .bind(with: self) { owner, _ in
                        let vm = CommentViewModel(bup: item)
                        let vc = CommentViewController(vm)
                        let navi = UINavigationController(rootViewController: vc)
                        owner.present(navi, animated: true)
                    }
                    .disposed(by: cell.disposeBag)

                return cell
            }
            .disposed(by: disposeBag)

        output.likeStatus
            .bind(to: mainView.tableView.rx.likeButtonUpdate)
            .disposed(by: disposeBag)
    }

    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}
