//
//  TodoNewsfeedViewModel.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/11/28.
//

import Foundation
import RxCocoa
import RxSwift

final class BupNewsfeedViewModel: ViewModelType {
    private let disposeBag = DisposeBag()

    private var baseItems: [Bup] = []
    let items = BehaviorRelay<[Bup]>(value: [])

    private let baseParameters = PostReadRequest(next: nil)
    private lazy var nextParameters = baseParameters

    var likeState: [Int: Bool] = [:]

    struct Input {
        let trigger: Observable<Void>
        let prefetchRows: ControlEvent<[IndexPath]>
        let postCreatorId: PublishRelay<String>
        let rowOfLikebutton: PublishRelay<Int>
        let didTapLikeButtonOfId: PublishRelay<String>
        let likeState: PublishRelay<(row: Int, isSelected: Bool)>
    }

    struct Output {
        let items: BehaviorRelay<[Bup]>
        let fetching: Driver<Bool>
        let postCreatorState: PublishRelay<(isMine: Bool, id: String)>
        let error: Driver<NetworkError>
    }

    func transform(input: Input) -> Output {
        // MARK: - Output
        let postCreatorState = PublishRelay<(isMine: Bool, id: String)>()

        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()

        input.trigger
            .flatMapLatest { [unowned self] _ in
                return NetworkManager.shared.request(
                    type: PostReadResponseDTO.self,
                    api: PostRouter.read(parameters: self.baseParameters),
                    error: NetworkError.PostReadError.self
                )
                .trackActivity(activityIndicator)
                .trackError(errorTracker)
                .catch { _ in Observable.empty() }
                .map { $0.toDomain() }
            }
            .bind(with: self) { owner, domain in
                owner.nextParameters = PostReadRequest(next: domain.nextCursor)
                owner.baseItems = domain.bups
                owner.items.accept(owner.baseItems)
            }
            .disposed(by: disposeBag)

        let fetching = activityIndicator.asDriver()
        let errors = errorTracker
            .compactMap { $0 as? NetworkError }
            .asDriver()

        input.prefetchRows
            .bind(with: self) { owner, indexPaths in
                for indexPath in indexPaths {
                    if indexPath.row == owner.baseItems.count - 1 {
                        if let next = owner.nextParameters.next, next != "0" {
                            NetworkManager.shared.request(
                                type: PostReadResponseDTO.self,
                                api: PostRouter.read(parameters: self.nextParameters),
                                error: NetworkError.PostReadError.self
                            )
                            .catch { error in
                                return Single.never()
                            }
                            .trackActivity(activityIndicator)
                            .map { $0.toDomain() }
                            .bind(with: self) { owner, domain in
                                owner.nextParameters = PostReadRequest(next: domain.nextCursor)
                                owner.baseItems += domain.bups
                                owner.items.accept(owner.baseItems)
                            }
                            .disposed(by: owner.disposeBag)
                        }
                    }
                }
            }
            .disposed(by: disposeBag)

        // 포스트 주인
        input.postCreatorId
            .bind(with: self) { owner, postCreatorId in
                let myId = KeychainManager.read(key: KeychainKey.id.rawValue) ?? ""

                // 내 게시글인가
                if myId == postCreatorId {
                    postCreatorState.accept((true, myId))
                // 다른 사람 게시글인가
                } else {
                    postCreatorState.accept((false, postCreatorId))
                }
            }
            .disposed(by: disposeBag)

        // 삭제 버튼 눌렸다면
        NotificationCenterManager.removeBup
            .addObserver()
            .compactMap { $0 as? Int }
            .bind(with: self) { owner, row in
                owner.baseItems.remove(at: row)
                owner.items.accept(owner.baseItems)
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
            items: items,
            fetching: fetching,
            postCreatorState: postCreatorState,          
            error: errors
        )
    }

}
