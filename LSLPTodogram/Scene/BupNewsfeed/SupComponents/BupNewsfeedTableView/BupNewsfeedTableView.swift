//
//  BupNewsfeedTableView.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/17.
//

import UIKit
import RxCocoa
import RxSwift

final class BupNewsfeedTableView: BaseTableView {
    private let disposeBag = DisposeBag()

    func bind(_ viewModel: BupNewsfeedTableViewModel) {
        let likeInBup = PublishSubject<Bup>()
        let commentInBup = PublishSubject<Bup>()

        let input = BupNewsfeedTableViewModel.Input(
            likeInBup: likeInBup,
            commentInBup: commentInBup,
            prefetchRows: self.rx.prefetchRows
        )
        let output = viewModel.transform(input: input)

        output.items
            .drive(self.rx.items) { tv, row, item in
                guard let cell = tv.dequeueReusableCell(
                    withIdentifier: BupCell.identifier
                ) as? BupCell else {return UITableViewCell()}

                cell.configure(item)

                cell.bupView.communicationView.likeButton.rx.tap
                    .withLatestFrom(Observable.just(item))
                    .bind(to: likeInBup)
                    .disposed(by: cell.disposeBag)

                cell.bupView.communicationView.commentCountButton.rx.tap
                    .withLatestFrom(Observable.just(item))
                    .bind(to: commentInBup)
                    .disposed(by: cell.disposeBag)

                output.likeStatus
                    .emit(to: cell.bupView.communicationView.likeButton.rx.isSelected)
                    .disposed(by: cell.disposeBag)

                return cell
            }
            .disposed(by: disposeBag)
    }

    override func initialAttributes() {
        super.initialAttributes()

        sectionHeaderTopPadding = 0
        rowHeight = UITableView.automaticDimension
        register(BupCell.self, forCellReuseIdentifier: BupCell.identifier)
    }

}
