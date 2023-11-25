//
//  LoginViewModel.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/11/20.
//

import Foundation
import RxCocoa
import RxSwift

final class LoginViewModel: ViewModelType {
    private let disposeBag = DisposeBag()

    struct Input {
        let email: ControlProperty<String?>
        let password: ControlProperty<String?>
        let loginButtonTapped: ControlEvent<Void>
        let joinButtonTapped: ControlEvent<Void>
    }

    struct Output {
        let loginErrorDescription: PublishRelay<String>
        let pushToJoin: PublishRelay<Void>
    }

    func transform(input: Input) -> Output {
        let loginErrorDescription = PublishRelay<String>()
        let pushToJoin = PublishRelay<Void>()

        let loginInfo = Observable
            .combineLatest(
                input.email.orEmpty,
                input.password.orEmpty
            )

        input.loginButtonTapped
            .withLatestFrom(loginInfo) { (_, info) -> (email: String, password: String) in
                return (info.0, info.1)
            }
            .flatMapLatest { (email: String, password: String) in
                return NetworkManager.shared.request(
                    type: LoginResponse.self,
                    api: Router.login(email: email, password: password)
                )
                .catch { error in
                    let statusCode = error.asAFError?.responseCode ?? 500
                    let loginError = LoginError(rawValue: statusCode) ?? .서버_에러
                    loginErrorDescription.accept(loginError.description)

                    return Single.just(LoginResponse(isError: true))
                }
            }
            .filter { !$0.isError }
            .bind(with: self) { owner, loginResponse in
                // TODO: UserDefeaults에 토큰 저장 => KeyChain에 토큰 저장
                // TODO: 다음 화면으로 이동
                print("성공")
            }
            .disposed(by: disposeBag)

        input.joinButtonTapped
            .bind(with: self) { owner, void in
                pushToJoin.accept(void)
            }
            .disposed(by: disposeBag)


        return Output(
            loginErrorDescription: loginErrorDescription,
            pushToJoin: pushToJoin
        )
    }

}
