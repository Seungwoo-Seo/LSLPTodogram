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

        mainView.tableView.bind(viewModel.bupNewsfeedTableViewModel)

        let input = BupNewsfeedViewModel.Input(
            prefetchRows: mainView.tableView.rx.prefetchRows
        )
        let output = viewModel.transform(input: input)

        output.presentCommentViewController
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
