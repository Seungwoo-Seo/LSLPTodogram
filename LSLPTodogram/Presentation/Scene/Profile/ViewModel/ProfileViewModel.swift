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

    private let baseParameters = PostReadRequest(next: nil)
    private lazy var nextParameters = baseParameters

    struct Input {
        let trigger: Observable<Void>
        let prefetchRows: ControlEvent<[IndexPath]>
        let rowOfLikebutton: PublishRelay<Int>
    }

    struct Output {
        let items: BehaviorRelay<[ProfileItemIdentifiable]>
        let fetching: Driver<Bool>
//        let likeStatus: PublishRelay<(row: Int, status: Bool, bup: Bup)>
        let error: Driver<NetworkError>
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

        return Output(
            items: items,
            fetching: fetching,
            error: errors
        )
    }

}
