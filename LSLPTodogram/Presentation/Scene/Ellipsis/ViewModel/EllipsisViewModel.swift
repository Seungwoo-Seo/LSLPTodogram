//
//  EllipsisViewModel.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2024/01/09.
//

import Foundation
import RxCocoa
import RxSwift

final class EllipsisViewModel: ViewModelType {
    private let disposeBag = DisposeBag()

    let cellInfo: (row: Int, bup: Bup)

    private var baseItems: [String] = ["삭제하기"]
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

        // 삭제
        input.modelSelected
            .filter { $0 == "삭제하기" }
            .flatMapLatest { [unowned self] _ in
                return NetworkManager.shared.request(
                    type: PostDeleteResponse.self,
                    api: PostRouter.delete(id: self.cellInfo.bup.id),
                    error: NetworkError.PostDeleteError.self
                )
                .trackActivity(activityIndicator)
                .trackError(errorTracker)
                .catch { _ in Observable.empty() }
                .map { _ in self.cellInfo.row }
            }
            .bind(with: self) { owner, row in
                NotificationCenterManager.removeBup.post(object: row)
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
