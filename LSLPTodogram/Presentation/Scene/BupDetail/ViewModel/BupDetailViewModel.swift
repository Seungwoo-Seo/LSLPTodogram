//
//  BupDetailViewModel.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2024/01/09.
//

import Foundation
import RxCocoa
import RxSwift

final class BupDetailViewModel: ViewModelType {
    private let disposeBag = DisposeBag()

    private let postId: String
    private let hostId: String

    private var baseItems: [BupDetailItemIdentifiable] = []
    let items: BehaviorSubject<[BupDetailItemIdentifiable]> = BehaviorSubject(value: [])

    var likeState: [Int: Bool] = [:]

    init(postId: String, hostId: String) {
        self.postId = postId
        self.hostId = hostId
    }

    struct Input {
        let trigger: Observable<Void>
        let rowOfLikebutton: PublishRelay<Int>
        let didTapLikeButtonOfId: PublishRelay<String>
        let likeState: PublishRelay<(row: Int, isSelected: Bool)>
    }

    struct Output {
        let fetching: Driver<Bool>
        let error: Driver<NetworkError>
        let items: Driver<[BupDetailItemIdentifiable]>
    }

    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()

        let fetching = activityIndicator.asDriver()
        let errors = errorTracker
            .compactMap { $0 as? NetworkError }
            .asDriver()

        input.trigger
            .flatMapLatest { [unowned self] _ in
                return NetworkManager.shared.request(
                    type: PostDTO.self,
                    api: PostRouter.singleRead(postId: self.postId),
                    error: NetworkError.PostReadError.self
                )
                .trackActivity(activityIndicator)
                .trackError(errorTracker)
                .catch { _ in Observable.empty() }
                .map { [unowned self] in $0.toBup(hostID: self.hostId) }
            }
            .bind(with: self) { owner, bup in
                owner.baseItems.removeAll()
                owner.baseItems.insert(BupDetailItemIdentifiable.detail(bup), at: 0)
                if let comments = bup.comments {
                    comments.forEach { owner.baseItems.append(BupDetailItemIdentifiable.comment($0)) }
                }
                owner.items.onNext(owner.baseItems)
            }
            .disposed(by: disposeBag)

        // MARK: - likeButton
        input.didTapLikeButtonOfId
            .flatMapLatest { (id) in
                return NetworkManager.shared.request(
                    type: LikeUpdateResponseDTO.self,
                    api: LikeRouter.update(id: id),
                    error: NetworkError.LikeUpdateError.self
                )
                .trackActivity(activityIndicator)
                .trackError(errorTracker)
                .catch { _ in Observable.empty() }
                .map { $0.toDomain() }
            }
            .withLatestFrom(input.likeState) { (domain: $0, likeState: $1) }
            .bind(with: self) { owner, value in
                // MARK: 현재로썬 굳이 response 값을 사용할 필요가 없어졌다.
            }
            .disposed(by: disposeBag)

        input.likeState
            .bind(with: self) { owner, localLikeState in
                owner.likeState.updateValue(localLikeState.isSelected, forKey: localLikeState.row)
            }
            .disposed(by: disposeBag)

        return Output(
            fetching: fetching,
            error: errors,
            items: items.asDriver(onErrorJustReturn: [])
        )
    }

}
