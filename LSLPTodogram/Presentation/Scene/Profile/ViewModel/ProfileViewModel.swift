//
//  ProfileViewModel.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/10.
//

import Foundation
import RxCocoa
import RxSwift

final class ProfileViewModel: ViewModelType {
    private let disposeBag = DisposeBag()

    private var baseItems: [ProfileItemIdentifiable] = []
    let items: BehaviorRelay<[ProfileItemIdentifiable]> = BehaviorRelay(value: [])

    private var commentBaseItems: [ProfileItemIdentifiable] = [
        ProfileItemIdentifiable.empty("아직 답글을 게시하지 않았습니다.")
    ]
    private var repostBaseItems: [ProfileItemIdentifiable] = [
        ProfileItemIdentifiable.empty("아직 Bup을 리포스트하지 않았습니다.")
    ]

    private let baseParameters = PostReadRequest(next: nil)
    private lazy var nextParameters = baseParameters

    var likeState: [Int: Bool] = [:]

    let segmentIndex = BehaviorRelay(value: 0)

    struct Input {
        let trigger: Observable<Void>
        let prefetchRows: ControlEvent<[IndexPath]>
        let rowOfLikebutton: PublishRelay<Int>
        let didTapLikeButtonOfId: PublishRelay<String>
        let likeState: PublishRelay<(row: Int, isSelected: Bool)>
    }

    struct Output {
        let items: BehaviorRelay<[ProfileItemIdentifiable]>
        let fetching: Driver<Bool>
        let error: Driver<NetworkError>
        let changedSegmentItems: PublishRelay<[ProfileItemIdentifiable]>
    }

    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()

        let fetching = activityIndicator.asDriver()
        let errors = errorTracker
            .compactMap { $0 as? NetworkError }
            .asDriver()

        let myProfile = input.trigger
            .flatMapLatest { _ in
                return NetworkManager.shared.request(
                    type: ProfileResponseDTO.self,
                    api: ProfileRouter.read,
                    error: NetworkError.ProfileReadError.self
                )
                .trackActivity(activityIndicator)
                .trackError(errorTracker)
                .catch { _ in Observable.empty() }
                .map { $0.toDomain() }
            }

        myProfile
            .bind(with: self) { owner, domain in
                // 최초로 데이터를 가져오거나 새로고침하면 기존 캐시를 다 지워준다.
                owner.likeState.removeAll()
                owner.baseItems.removeAll()
                owner.baseItems.insert(ProfileItemIdentifiable.profile(domain), at: 0)
                owner.items.accept(owner.baseItems)
            }
            .disposed(by: disposeBag)

        myProfile
            .flatMapLatest { [unowned self] (profile) in
                return NetworkManager.shared.request(
                    type: PostReadResponseDTO.self,
                    api: PostRouter.userRead(id: profile._id, parameters: self.baseParameters),
                    error: NetworkError.PostReadError.self
                )
                .trackActivity(activityIndicator)
                .trackError(errorTracker)
                .catch { _ in Observable.empty() }
                .map { $0.toDomain() }
            }
            .bind(with: self) { owner, domain in
                owner.nextParameters = PostReadRequest(next: domain.nextCursor)
                let bups = domain.bups.map { ProfileItemIdentifiable.bup($0) }
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
                                api: PostRouter.read(parameters: self.nextParameters),
                                error: NetworkError.PostReadError.self
                            )
                            .trackActivity(activityIndicator)
                            .trackError(errorTracker)
                            .catch { _ in Observable.empty() }
                            .map { $0.toDomain() }
                            .bind(with: self) { owner, domain in
                                owner.nextParameters = PostReadRequest(next: domain.nextCursor)
                                let bups = domain.bups.map { ProfileItemIdentifiable.bup($0) }
                                owner.baseItems.append(contentsOf: bups)
                                owner.items.accept(owner.baseItems)
                            }
                            .disposed(by: owner.disposeBag)
                        }
                    }
                }
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

        let changedSegmentItems: PublishRelay<[ProfileItemIdentifiable]> = PublishRelay()

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
            changedSegmentItems: changedSegmentItems
        )
    }

}
