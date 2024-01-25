//
//  FollowerListViewModel.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2024/01/09.
//

import Foundation
import RxCocoa
import RxSwift

final class FollowerListViewModel: ViewModelType {
    private let disposeBag = DisposeBag()

    private var baseItems: [Follower] = []
    let items: BehaviorSubject<[Follower]> = BehaviorSubject(value: [])

    init(followers: [Follower]) {
        self.baseItems = followers
    }

    struct Input {
        let trigger: Observable<Void>
    }

    struct Output {
        let items: Driver<[Follower]>
    }

    func transform(input: Input) -> Output {
//        let activityIndicator = ActivityIndicator()
//        let errorTracker = ErrorTracker()
//
//        let fetching = activityIndicator.asDriver()
//        let errors = errorTracker
//            .compactMap { $0 as? NetworkError }
//            .asDriver()

        input.trigger
            .bind(with: self) { owner, _ in
                owner.items.onNext(owner.baseItems)
            }
            .disposed(by: disposeBag)

        return Output(
            items: items.asDriver(onErrorJustReturn: [])
        )
    }

}
