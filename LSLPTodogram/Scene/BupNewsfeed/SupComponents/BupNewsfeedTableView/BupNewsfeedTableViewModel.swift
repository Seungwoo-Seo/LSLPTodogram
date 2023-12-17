//
//  BupNewsfeedTableViewModel.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/17.
//

import Foundation
import RxCocoa
import RxSwift

struct BupNewsfeedTableViewModel: ViewModelType {
    private let disposeBag = DisposeBag()

    // 전달 받을
    let baseItems = PublishSubject<[Bup]>()
    let baseLike = PublishSubject<Like>()

    // 사용할
    let items: Driver<[Bup]>
    let likeStatus: Signal<Bool>

    // 보낼
    let likeInBup = PublishSubject<Bup>()
    let commentInBup = PublishSubject<Bup>()
    let prefetchRows = PublishSubject<[IndexPath]>()

    init() {
        self.items = baseItems
            .asDriver(onErrorJustReturn: [])
        self.likeStatus = baseLike
            .map { $0.status }
            .asSignal(onErrorJustReturn: false)
    }

    struct Input {
        let likeInBup: PublishSubject<Bup>
        let commentInBup: PublishSubject<Bup>
        let prefetchRows: ControlEvent<[IndexPath]>
    }

    struct Output {
        let items: Driver<[Bup]>
        let likeStatus: Signal<Bool>
    }

    func transform(input: Input) -> Output {
        input.likeInBup
            .bind(to: likeInBup)
            .disposed(by: disposeBag)

        input.commentInBup
            .bind(to: commentInBup)
            .disposed(by: disposeBag)

        input.prefetchRows
            .bind(to: prefetchRows)
            .disposed(by: disposeBag)

        return Output(
            items: items,
            likeStatus: likeStatus
        )
    }

}
