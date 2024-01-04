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

    let items: BehaviorRelay<[ProfileItemIdentifiable]> = BehaviorRelay(value: [])

    struct Input {

    }

    struct Output {
        let items: BehaviorRelay<[ProfileItemIdentifiable]>
    }

    func transform(input: Input) -> Output {
        let profile = PublishRelay<Profile>()

        let token = BehaviorRelay(value: KeychainManager.read(key: KeychainKey.token.rawValue) ?? "")
        let parameters = BehaviorRelay(value: PostReadRequest(next: nil, limit: 3, product_id: "PersonalTodo"))

        // 1. 토큰 확인
        let isProfile = token
            .flatMapLatest {
                return NetworkManager.shared.request(
                    type: ProfileResponseDTO.self,
                    api: ProfileRouter.read(token: $0)
                )
                .catch { error in
                    print("❌ 59번 줄이요", error.localizedDescription)
                    return Single.never()
                }
            }
            .withUnretained(self)
            .map { (owner, response) in
                return response.toDomain
            }

        isProfile
            .bind(with: self) { owner, result in
                profile.accept(result)
            }
            .disposed(by: disposeBag)

        isProfile
            .withLatestFrom(Observable
                .combineLatest(token, parameters)) { profile, tokenParameters in
                    return (profile._id, tokenParameters.0, tokenParameters.1)
                }
                .flatMapLatest { (id, token, paramters) in
                    return NetworkManager.shared.request(
                        type: PostReadResponse.self,
                        api: PostRouter.userRead(token: token, id: id, parameters: paramters)
                    )
                    .catch { error in
                        print(error.localizedDescription)
                        return Single.never()
                    }
                }
                .withLatestFrom(profile) { responseDTO, profile in
                    return (profile: profile, response: responseDTO)
                }
                .bind(with: self) { owner, value in
                    let profile = value.profile
                    let bupList = value.response.data.map { ProfileItemIdentifiable.bup($0.toBup) }

                    let lists = [ProfileItemIdentifiable.profile(profile)] + bupList

                    owner.items.accept(lists)
                }
                .disposed(by: disposeBag)

        return Output(items: items)
    }

}
