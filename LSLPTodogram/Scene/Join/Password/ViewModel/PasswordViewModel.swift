//
//  PasswordViewModel.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/11/23.
//

import Foundation
import RxCocoa
import RxSwift

final class PasswordViewModel: ViewModelType {
    private let disposeBag = DisposeBag()

    let password = BehaviorRelay(value: "")
    let scrollToNext = PublishRelay<Void>()
    let scrollToPrev = PublishRelay<Void>()

    struct Input {
        let passwordText: Driver<String>
        let reconfirmText: Driver<String>
        let nextButtonTapped: ControlEvent<Void>
        let prevButtonTapped: ControlEvent<Void>
    }

    struct Output {
        let passwordState: BehaviorRelay<Result<PasswordSuccess, PasswordError>>
        let reconfirmState: BehaviorRelay<Result<ReconfrimSuccess, ReconfrimError>>
    }

    func transform(input: Input) -> Output {
        let passwordState = BehaviorRelay<Result<PasswordSuccess, PasswordError>>(value: .failure(.never))
        let reconfirmState = BehaviorRelay<Result<ReconfrimSuccess, ReconfrimError>>(value: .failure(.never))

        let passwordAndReconfirm = Driver
            .combineLatest(input.passwordText, input.reconfirmText)

        // 비밀번호가 비었을 때
        passwordAndReconfirm
            .skip(1)
            .filter { $0.0.isEmpty }
            .drive(with: self) { owner, _ in
                passwordState.accept(.failure(.empty))
            }
            .disposed(by: disposeBag)

        // 비밀번호가 정규식을 통과하지 못할 때
        passwordAndReconfirm
            .filter { !$0.0.isEmpty }
            .filter { [weak self] in
                guard let owner = self else {return false}
                return !owner.isValidPassword($0.0)
            }
            .drive(with: self) { owner, _ in
                passwordState.accept(.failure(.invalid))
            }
            .disposed(by: disposeBag)

        // 비밀번호를 사용할 수 있을 때
        passwordAndReconfirm
            .filter { !$0.0.isEmpty }
            .filter { [weak self] in
                guard let owner = self else {return false}
                return owner.isValidPassword($0.0)
            }
            .drive(with: self) { owner, _ in
                passwordState.accept(.success(.availablePassword))
            }
            .disposed(by: disposeBag)

        // 재확인 비밀번호가 비었을 때
        passwordAndReconfirm
            .filter { $0.1.isEmpty }
            .drive(with: self) { owner, _ in
                reconfirmState.accept(.failure(.never))
            }
            .disposed(by: disposeBag)

        // 재확인 비밀번호와 비밀번호가 동일할 때
        passwordAndReconfirm
            .filter { !$0.1.isEmpty }
            .filter { $0.0 == $0.1 }
            .drive(with: self) { owner, _ in
                reconfirmState.accept(.success(.compareSame))
            }
            .disposed(by: disposeBag)

        // 재확인 비밀번호와 비밀번호가 동일하지 않을 때
        passwordAndReconfirm
            .filter { !$0.1.isEmpty }
            .filter { $0.0 != $0.1 }
            .drive(with: self) { owner, _ in
                reconfirmState.accept(.failure(.compareNotSame))
            }
            .disposed(by: disposeBag)

        let combineState = Observable
            .combineLatest(passwordState, reconfirmState)

        // 다음 버튼 눌렀을 때
        input.nextButtonTapped
            .withLatestFrom(combineState)
            .filter {
                switch $0.0 {
                case .success: return true
                case .failure(let error):
                    switch error {
                    case .never:
                        passwordState.accept(.failure(.empty))
                    default:
                        passwordState.accept(.failure(error))
                    }
                    return false
                }
            }
            .filter {
                switch $0.1 {
                case .success: return true
                case .failure(let error):
                    switch error {
                    case .never:
                        reconfirmState.accept(.failure(.empty))
                    default:
                        reconfirmState.accept(.failure(error))
                    }
                    return false
                }
            }
            .bind(with: self) { owner, _ in
                owner.scrollToNext.accept(Void())
            }
            .disposed(by: disposeBag)

        // 이전 버튼 눌렀을 때
        input.prevButtonTapped
            .bind(with: self) { owner, void in
                owner.scrollToPrev.accept(void)
            }
            .disposed(by: disposeBag)

        return Output(
            passwordState: passwordState,
            reconfirmState: reconfirmState
        )
    }

    private func isValidPassword(_ password: String) -> Bool {
        let regex = "^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[!@#$%^&*()_+=-]).{8,50}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: password)
    }

}
