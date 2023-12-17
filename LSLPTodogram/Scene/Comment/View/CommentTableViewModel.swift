//
//  CommentTableViewModel.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/17.
//

import Foundation
import RxCocoa
import RxSwift

struct CommentTableViewModel: ViewModelType {
    private let disposeBag = DisposeBag()

    // 상위로부터 전달 받고
    let baseItems = PublishSubject<[CommentItemIdentifiable]>()

    // 여기서 사용
    let items: Driver<[CommentItemIdentifiable]>

    // 상위로 전달
    let commet = PublishSubject<String>()

    init() {
        self.items = baseItems
            .asDriver(onErrorJustReturn: [])
    }

    struct Input {
        let comment: PublishSubject<String>
    }

    struct Output {
        let items: Driver<[CommentItemIdentifiable]>
    }

    func transform(input: Input) -> Output {
        input.comment
            .bind(to: commet)
            .disposed(by: disposeBag)

        return Output(items: items)
    }
}
