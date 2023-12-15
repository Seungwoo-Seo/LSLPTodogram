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

        let commentInBup = PublishRelay<Bup>()

        mainView.dataSource = UITableViewDiffableDataSource(
            tableView: mainView.tableView
        ) { tableView, indexPath, itemIdentifier in

            let cell = tableView.dequeueReusableCell(
                withIdentifier: BupCell.identifier,
                for: indexPath
            ) as! BupCell

            cell.bupView.communicationView.commentButton.rx.tap
                .withLatestFrom(cell.bup)
                .bind(to: commentInBup)
                .disposed(by: cell.disposeBag)

            cell.bup.accept(itemIdentifier)

            return cell
        }
        mainView.snapshot.appendSections(BupNewsfeedSection.allCases)
        mainView.dataSource.apply(mainView.snapshot)

        let input = BupNewsfeedViewModel.Input(
            prefetchRows: mainView.tableView.rx.prefetchRows,
            commentInBup: commentInBup
        )
        let output = viewModel.transform(input: input)

        output.bupList
            .bind(with: self) { owner, bupList in
                owner.mainView.snapshot.appendItems(bupList)
                owner.mainView.dataSource.apply(owner.mainView.snapshot)
            }
            .disposed(by: disposeBag)

        output.presentCommentViewController
            .debug()
            .bind(with: self) { owner, viewModel in
                let vc = CommentViewController(viewModel)
                let navi = UINavigationController(rootViewController: vc)
                owner.present(navi, animated: true)
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
