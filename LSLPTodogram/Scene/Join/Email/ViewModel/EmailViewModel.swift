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

    let email = PublishRelay<String>()
    let scrollToNext = PublishRelay<Void>()

    struct Input {
        let emailText: Observable<String>
        let validationButtonTapped: ControlEvent<Void>
        let nextButtonTapped: ControlEvent<Void>
    }

    struct Output {
        let emailState: PublishRelay<Result<EmailSuccess, EmailError>>
    }

    func transform(input: Input) -> Output {
        let emailState = PublishRelay<Result<EmailSuccess, EmailError>>()

        input.emailText
            .filter {
                if $0.isEmpty {
                    emailState.accept(.failure(.empty))
                    return false
                }
                return true
            } // 이메일 존재 여부 검사
            .filter { [weak self] in
                guard let owner = self else {return false}
                if !owner.isValidEmail($0) {
                    emailState.accept(.failure(.invalid))
                    return false
                }
                return true
            } // 이메일 유효성 검사
            .bind(with: self) { owner, email in
                emailState.accept(.success(.available))
            }
            .disposed(by: disposeBag)

        input.validationButtonTapped
            .withLatestFrom(input.emailText)
            .distinctUntilChanged()
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .filter {
                if $0.isEmpty {
                    emailState.accept(.failure(.empty))
                    return false
                }
                return true
            } // 이메일 존재 여부 검사
            .filter { [weak self] in
                guard let owner = self else {return false}
                if !owner.isValidEmail($0) {
                    emailState.accept(.failure(.invalid))
                    return false
                }
                return true
            } // 이메일 유효성 검사
            .flatMapLatest {
                return NetworkManager.shared.request(
                    type: EmailValidationResponse.self,
                    api: Router.emailChek(email: $0)
                )
                .catch { error in
                    let statusCode = error.asAFError?.responseCode ?? 500
                    let emailError = EmailError(rawValue: statusCode) ?? .server
                    emailState.accept(.failure(emailError))
                    return Single.never()
                }
            }
            .withLatestFrom(input.emailText) { response, email in
                return (response: response, email: email)
            }
            .bind(with: self) { owner, value in
                owner.email.accept(value.email)
                emailState.accept(.success(.duplicatePass(message: value.response.message)))
            }
            .disposed(by: disposeBag)

        let compareEmail = Observable
            .combineLatest(input.emailText, email)

        input.nextButtonTapped
            .withLatestFrom(input.emailText)
            .filter {
                if $0.isEmpty {
                    emailState.accept(.failure(.empty))
                    return false
                }
                return true
            } // 이메일 존재 여부 검사
            .filter { [weak self] in
                guard let owner = self else {return false}
                if !owner.isValidEmail($0) {
                    emailState.accept(.failure(.invalid))
                    return false
                }
                return true
            } // 이메일 유효성 검사
            .withLatestFrom(compareEmail) { _, compareEmail in
                return (inputEmail: compareEmail.0, currentEmail: compareEmail.1)
            }
            .filter {
                if !($0.inputEmail == $0.currentEmail) {
                    emailState.accept(.failure(.reconfirm))
                    return false
                }
                return true
            } // 검증 받지 않은 이메일 방지 로직
            .bind(with: self) { owner, _ in
                emailState.accept(.success(.duplicatePass(message: "사용 가능한 이메일입니다.")))
                owner.scrollToNext.accept(Void())
            }
            .disposed(by: disposeBag)

        return Output(
            emailState: emailState
        )
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }

}
