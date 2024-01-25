//
//  SettingViewModel.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2024/01/22.
//

import Foundation
import RxCocoa
import RxSwift

final class SettingViewModel: ViewModelType {
    private let disposeBag = DisposeBag()

    private let items: BehaviorSubject<[String]> = BehaviorSubject(value: ["로그아웃", "회원탈퇴"])

    struct Input {
        let modelSelected: ControlEvent<String>
    }

    struct Output {
        let items: Driver<[String]>
        let windowResetTrigger: PublishRelay<Void>
    }

    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()

        let logoutTrigger = PublishRelay<Void>()
        let withdrawTrigger = PublishRelay<Void>()

        let windowResetTrigger = PublishRelay<Void>()

        input.modelSelected
            .bind(with: self) { owner, string in
                if string == "로그아웃" {
                    logoutTrigger.accept(Void())
                } else {
                    withdrawTrigger.accept(Void())
                }
            }
            .disposed(by: disposeBag)

        logoutTrigger
            .bind(with: self) { owner, _ in
                KeychainManager.delete(key: KeychainKey.id.rawValue)
                KeychainManager.delete(key: KeychainKey.token.rawValue)
                KeychainManager.delete(key: KeychainKey.refresh.rawValue)
                windowResetTrigger.accept(Void())
            }
            .disposed(by: disposeBag)

        withdrawTrigger
            .flatMapLatest { _ in
                return NetworkManager.shared.request(
                    type: WithdrawResponse.self,
                    api: AccountRouter.withdraw,
                    error: NetworkError.WithdrawError.self
                )
                .trackActivity(activityIndicator)
                .trackError(errorTracker)
                .catch { _ in Observable.empty() }
            }
            .bind(with: self) { owner, reseponse in
                KeychainManager.delete(key: KeychainKey.id.rawValue)
                KeychainManager.delete(key: KeychainKey.token.rawValue)
                KeychainManager.delete(key: KeychainKey.refresh.rawValue)
                print(reseponse)
                windowResetTrigger.accept(Void())
            }
            .disposed(by: disposeBag)

        return Output(
            items: items.asDriver(onErrorJustReturn: []),
            windowResetTrigger: windowResetTrigger
        )
    }

}

