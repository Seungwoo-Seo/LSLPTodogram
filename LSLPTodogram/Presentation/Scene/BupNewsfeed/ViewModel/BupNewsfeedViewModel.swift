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

    struct Input {
        let trigger: Observable<Void>
        let prefetchRows: ControlEvent<[IndexPath]>
        let postCreatorId: PublishRelay<String>
        let rowOfLikebutton: PublishRelay<Int>
    }

    struct Output {
        let items: BehaviorRelay<[Bup]>
        let fetching: Driver<Bool>
        let postCreatorState: PublishRelay<(isMine: Bool, id: String)>
        let likeStatus: PublishRelay<(row: Int, status: Bool, bup: Bup)>
        let error: Driver<NetworkError>
    }

    func transform(input: Input) -> Output {
        // MARK: - Output
        let postCreatorState = PublishRelay<(isMine: Bool, id: String)>()
        let likeStatus = PublishRelay<(row: Int, status: Bool, bup: Bup)>()

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

        // 좋아요
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


        // MARK: - likeButton

        // 유저가 누른거임
        let localLikeState = input.rowOfLikebutton
            .withLatestFrom(items) { $1[$0].id }
            .flatMapLatest {
                return NetworkManager.shared.request(
                    type: LikeUpdateResponse.self,
                    api: LikeRouter.update(id: $0)
                )
                .catch { error in
                    print("❌", error.localizedDescription)
                    return Single.never()
                }
            }
            .map { $0.toDomain.status }
            .withLatestFrom(input.rowOfLikebutton) { [unowned self] in
                return (row: $1, status: $0, bup: self.baseItems[$1])
            }
            .share()

        // 컬렉션에 저장하고
        localLikeState
            .bind(to: likeStatus)
            .disposed(by: disposeBag)


        return Output(
            items: items,
            fetching: fetching,
            postCreatorState: postCreatorState,
            likeStatus: likeStatus,            
            error: errors
        )
    }

}
