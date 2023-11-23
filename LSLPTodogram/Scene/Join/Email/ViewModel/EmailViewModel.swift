//
//  EmailViewModel.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/11/22.
//

import Foundation
import RxCocoa
import RxSwift

final class EmailViewModel: ViewModelType {
    private let disposeBag = DisposeBag()

    struct Input {
        let emailText: ControlProperty<String?>
        let emailValidationButtonTapped: ControlEvent<Void>
        let nextButtonTapped: ControlEvent<Void>
    }

    struct Output {
        let localError: PublishRelay<String>
        let emailValidationError: PublishRelay<EmailValidationError>
        let emailSuccessMessage: PublishRelay<String>
    }

    func transform(input: Input) -> Output {
        let localError = PublishRelay<String>()
        let emailValidationError = PublishRelay<EmailValidationError>()
        let emailSuccessMessage = PublishRelay<String>()

        let email = input.emailValidationButtonTapped
            .withLatestFrom(input.emailText.orEmpty)
            .asDriver(onErrorJustReturn: "")

        email
            .filter { $0.isEmpty }
            .drive(with: self) { owner, _ in
                localError.accept("이메일을 입력하세요.")
            }
            .disposed(by: disposeBag)

        email
            .filter { !$0.isEmpty }
            .asObservable()
            .flatMapLatest {
                return NetworkManager.shared.request(
                    type: EmailValidationResponse.self,
                    api: Router.emailChek(email: $0)
                )
                .catch { error in
                    let statusCode = error.asAFError?.responseCode ?? 500
                    let evError = EmailValidationError(rawValue: statusCode) ?? .서버_에러
                    emailValidationError.accept(evError)
                    return Single.never()
                }
            }
            .bind(with: self) { owner, response in
                emailSuccessMessage.accept(response.message)
            }
            .disposed(by: disposeBag)

        return Output(
            localError: localError,
            emailValidationError: emailValidationError,
            emailSuccessMessage: emailSuccessMessage
        )
    }

}
