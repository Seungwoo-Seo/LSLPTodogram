//
//  OthersEllipsisViewModel.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2024/01/10.
//

import Foundation
import RxCocoa
import RxSwift

final class OthersEllipsisViewModel: ViewModelType {
    private let disposeBag = DisposeBag()

    let cellInfo: (row: Int, bup: Bup)

    private var baseItems: [String] = ["숨기기", "신고"]
    let items: BehaviorSubject<[String]> = BehaviorSubject(value: [])

    init(cellInfo: (row: Int, bup: Bup)) {
        self.cellInfo = cellInfo
    }

    struct Input {
        let trigger: Observable<Void>
        let modelSelected: ControlEvent<String>
    }

    struct Output {
        let items: Driver<[String]>
        let fetching: Driver<Bool>
        let error: Driver<NetworkError>
    }

    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()

        input.trigger
            .bind(with: self) { owner, _ in
                owner.items.onNext(owner.baseItems)
            }
            .disposed(by: disposeBag)

        return Output(
            items: items.asDriver(onErrorJustReturn: []),
            fetching: activityIndicator.asDriver(),
            error: errorTracker
                .compactMap { $0 as? NetworkError }
                .asDriver()
        )
    }

}

