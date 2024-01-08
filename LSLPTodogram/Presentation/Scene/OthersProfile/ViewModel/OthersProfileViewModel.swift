//
//  OthersProfileViewModel.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/19.
//

import Foundation
import RxCocoa
import RxSwift

final class OthersProfileViewModel: ViewModelType {
    private let disposeBag = DisposeBag()

    private var baseItems: [OthersProfileItemIdentifiable] = []
    let items: BehaviorRelay<[OthersProfileItemIdentifiable]> = BehaviorRelay(value: [])

    private var commentBaseItems: [OthersProfileItemIdentifiable] = [
        OthersProfileItemIdentifiable.empty("아직 답글을 게시하지 않았습니다.")
    ]
    private var repostBaseItems: [OthersProfileItemIdentifiable] = [
        OthersProfileItemIdentifiable.empty("아직 Bup을 리포스트하지 않았습니다.")
    ]

    private let baseParameters = PostReadRequest(next: nil)
    private lazy var nextParameters = baseParameters

    var likeState: [Int: Bool] = [:]

    let segmentIndex = BehaviorRelay(value: 0)

    let othersId: String

    init(othersId: String) {
        self.othersId = othersId
    }

    struct Input {
        let trigger: Observable<Void>
        let prefetchRows: ControlEvent<[IndexPath]>
        let followState: PublishRelay<(othersID: String, isSelected: Bool)>
        let rowOfLikebutton: PublishRelay<Int>
        let didTapLikeButtonOfId: PublishRelay<String>
        let likeState: PublishRelay<(row: Int, isSelected: Bool)>
    }

    struct Output {
        let items: BehaviorRelay<[OthersProfileItemIdentifiable]>
        let fetching: Driver<Bool>
        let error: Driver<NetworkError>
        let followButtonIsSelected: Signal<Bool>
        let changedSegmentItems: PublishRelay<[OthersProfileItemIdentifiable]>
    }

    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()

        let fetching = activityIndicator.asDriver()
        let errors = errorTracker
            .compactMap { $0 as? NetworkError }
            .asDriver()

        let othersProfile = input.trigger
            .flatMapLatest { [unowned self] _ in
                return NetworkManager.shared.request(
                    type: OthersProfileReadResponseDTO.self,
                    api: ProfileRouter.others(id: self.othersId),
                    error: NetworkError.OthersProfileReadError.self
                )
                .trackActivity(activityIndicator)
                .trackError(errorTracker)
                .catch { _ in Observable.empty() }
                .map { $0.toDomain() }
            }

        othersProfile
            .bind(with: self) { owner, domain in
                owner.likeState.removeAll()
                owner.baseItems.removeAll()
                owner.baseItems.insert(OthersProfileItemIdentifiable.profile(domain), at: 0)
                owner.items.accept(owner.baseItems)
            }
            .disposed(by: disposeBag)

        othersProfile
            .flatMapLatest { [unowned self] (othersProfile) in
                return NetworkManager.shared.request(
                    type: PostReadResponseDTO.self,
                    api: PostRouter.userRead(id: othersProfile.id, parameters: self.baseParameters),
                    error: NetworkError.PostReadError.self
                )
                .trackActivity(activityIndicator)
                .trackError(errorTracker)
                .catch { _ in Observable.empty() }
                .map { $0.toDomain() }
            }
            .bind(with: self) { owner, domain in
                owner.nextParameters = PostReadRequest(next: domain.nextCursor)
                let bups = domain.bups.map { OthersProfileItemIdentifiable.bup($0) }
                owner.baseItems.append(contentsOf: bups)
                owner.items.accept(owner.baseItems)
            }
            .disposed(by: disposeBag)

        input.prefetchRows
            .bind(with: self) { owner, indexPaths in
                for indexPath in indexPaths {
                    if indexPath.row == owner.baseItems.count - 2 {
                        if let next = owner.nextParameters.next, next != "0" {
                            NetworkManager.shared.request(
                                type: PostReadResponseDTO.self,
                                api: PostRouter.userRead(id: owner.othersId, parameters: owner.nextParameters),
                                error: NetworkError.PostReadError.self
                            )
                            .trackActivity(activityIndicator)
                            .trackError(errorTracker)
                            .catch { _ in Observable.empty() }
                            .map { $0.toDomain() }
                            .bind(with: self) { owner, domain in
                                owner.nextParameters = PostReadRequest(next: domain.nextCursor)
                                let bups = domain.bups.map { OthersProfileItemIdentifiable.bup($0) }
                                owner.baseItems.append(contentsOf: bups)
                                owner.items.accept(owner.baseItems)
                            }
                            .disposed(by: owner.disposeBag)
                        }
                    }
                }
            }
            .disposed(by: disposeBag)

        // MARK: - follow
        let followState = input.followState
            .share()

        let followButtonIsSelected: PublishSubject<Bool> = PublishSubject()

        followState
            .debug()
            .filter { !$0.isSelected }
            .flatMapLatest {
                NetworkManager.shared.request(
                    type: UnFollowResponse.self,
                    api: FollowRouter.unfollow(id: $0.othersID),
                    error: NetworkError.UnFollowError.self
                )
                .trackActivity(activityIndicator)
                .trackError(errorTracker)
                .catch { _ in Observable.empty() }
                .map { $0.status }
            }
            .debug()
            .bind(to: followButtonIsSelected)
            .disposed(by: disposeBag)

        followState
            .debug()
            .filter { $0.isSelected }
            .flatMapLatest {
                NetworkManager.shared.request(
                    type: FollowResponse.self,
                    api: FollowRouter.follow(id: $0.othersID),
                    error: NetworkError.FollowError.self
                )
                .trackActivity(activityIndicator)
                .trackError(errorTracker)
                .catch { _ in Observable.empty() }
                .map { $0.status }
            }
            .debug()
            .bind(to: followButtonIsSelected)
            .disposed(by: disposeBag)

        // MARK: - like
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

        let changedSegmentItems: PublishRelay<[OthersProfileItemIdentifiable]> = PublishRelay()

        segmentIndex
            .distinctUntilChanged()
            .bind(with: self) { owner, index in
                if index == 0 {
                    if !owner.baseItems.isEmpty {
                        changedSegmentItems.accept(Array(owner.baseItems.suffix(from: 1)))
                    }
                } else if index == 1 {
                    changedSegmentItems.accept(owner.commentBaseItems)
                } else {
                    changedSegmentItems.accept(owner.repostBaseItems)
                }
            }
            .disposed(by: disposeBag)

        return Output(
            items: items,
            fetching: fetching,
            error: errors,
            followButtonIsSelected: followButtonIsSelected.asSignal { _ in return Signal.empty() },
            changedSegmentItems: changedSegmentItems
        )
    }

}
