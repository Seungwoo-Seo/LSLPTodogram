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

    let id: BehaviorRelay<String>

    init(id: String) {
        self.id = BehaviorRelay(value: id)
    }

    let items: BehaviorRelay<[OthersProfileItemIdentifiable]> = BehaviorRelay(value: [])

    struct Input {
        let itemOfFollowButton: PublishRelay<OthersProfile>
    }

    struct Output {
        let items: BehaviorRelay<[OthersProfileItemIdentifiable]>
        let followState: PublishRelay<Bool>
    }

    func transform(input: Input) -> Output {
        let othersProfile = PublishRelay<OthersProfile>()
        let followState = PublishRelay<Bool>()

        let token = BehaviorRelay(value: KeychainManager.read(key: KeychainKey.token.rawValue) ?? "")
        let myId = BehaviorRelay(value: KeychainManager.read(key: KeychainKey.id.rawValue) ?? "")
        let parameters = BehaviorRelay(value: PostReadRequest(next: nil))


        // 1. 토큰 확인
        let isProfile = Observable
            .combineLatest(token, id)
            .debug()
            .flatMapLatest {
                return NetworkManager.shared.request(
                    type: OthersProfileResponseDTO.self,
                    api: ProfileRouter.others(id: $1)
                )
                .catch { error in
                    print("❌ 59번 줄이요", error.localizedDescription)
                    return Single.never()
                }
            }
            .withLatestFrom(myId) { $0.toDomain(myId: $1) }

        isProfile
            .bind(with: self) { owner, result in
                othersProfile.accept(result)
            }
            .disposed(by: disposeBag)

        isProfile
            .withLatestFrom(Observable
                .combineLatest(token, parameters)) { profile, tokenParameters in
                    return (profile.id, tokenParameters.0, tokenParameters.1)
                }
                .flatMapLatest { (id, token, paramters) in
                    return NetworkManager.shared.request(
                        type: PostReadResponseDTO.self,
                        api: PostRouter.userRead(id: id, parameters: paramters)
                    )
                    .catch { error in
                        print(error.localizedDescription)
                        return Single.never()
                    }
                }
                .withLatestFrom(othersProfile) { responseDTO, profile in
                    return (profile: profile, response: responseDTO)
                }
                .bind(with: self) { owner, value in
                    let profile = value.profile
                    let bupList = value.response.data.map { OthersProfileItemIdentifiable.bup($0.toBup()) }

                    let lists = [OthersProfileItemIdentifiable.profile(profile)] + bupList

                    owner.items.accept(lists)
                }
                .disposed(by: disposeBag)

        input.itemOfFollowButton
            .withLatestFrom(token) { (token: $1, id: $0.id) }
            .flatMapLatest {
                return NetworkManager.shared.request(
                    type: FollowResponse.self,
                    api: FollowRouter.follow(id: $0.id)
                )
                .catch { error in
                    print("100 ❌", error.localizedDescription)
                    return Single.never()
                }
            }
            .map { $0.status }
            .bind(to: followState)
            .disposed(by: disposeBag)

        return Output(
            items: items,
            followState: followState
        )
    }

}
