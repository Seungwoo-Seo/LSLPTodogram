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
    private let mainView = BupView()
    private let disposeBag = DisposeBag()

    init(_ viewModel: BupNewsfeedViewModel) {
        super.init(nibName: nil, bundle: nil)

        mainView.configureDataSource(viewModel)

        let input = BupNewsfeedViewModel.Input(
            prefetchItems: mainView.collectionView.rx.prefetchItems
        )
        let output = viewModel.transform(input: input)

        output.bupContainerList
            .bind(with: self) { owner, bupContainerList in
                var snapshot = NSDiffableDataSourceSnapshot<BupContainer, BupContent>()
                snapshot.appendSections(bupContainerList)
                for bupContainer in bupContainerList {
                    snapshot.appendItems(bupContainer.bupContents, toSection: bupContainer)
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
