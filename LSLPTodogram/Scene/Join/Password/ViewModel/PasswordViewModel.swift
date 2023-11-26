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
        let passwordText: ControlProperty<String?>
        let sameText: ControlProperty<String?>
        let nextButtonTapped: ControlEvent<Void>
        let prevButtonTapped: ControlEvent<Void>
    }

    struct Output {
        let comparisonResult: PublishRelay<Bool>
        let hideSameErrorLabel: BehaviorRelay<Bool>
        let localError: PublishRelay<String>
    }

    func transform(input: Input) -> Output {
        let comparisonResult = PublishRelay<Bool>()
        let hideSameErrorLabel = BehaviorRelay(value: true)
        let localError = PublishRelay<String>()
        let passwordState = BehaviorRelay(value: false)

        passwordState
            .filter { $0 }
            .withLatestFrom(input.passwordText.orEmpty)
            .bind(with: self) { owner, password in
                owner.password.accept(password)
            }
            .disposed(by: disposeBag)

        let comparisonTexts = Observable
            .combineLatest(
                input.passwordText.orEmpty,
                input.sameText.orEmpty
            )
            .share()

        comparisonTexts
            .filter { !$0.0.isEmpty && !$0.1.isEmpty }
            .map { $0.0 == $0.1 }
            .bind(with: self) { owner, bool in
                passwordState.accept(bool)
                comparisonResult.accept(bool)
            }
            .disposed(by: disposeBag)

        comparisonTexts
            .filter { $0.1.isEmpty }
            .map { _ in true }
            .bind(with: self) { owner, bool in
                hideSameErrorLabel.accept(bool)
            }
            .disposed(by: disposeBag)


        let isNextOk = input.nextButtonTapped
            .withLatestFrom(passwordState)
            .share()

        isNextOk
            .filter { $0 }
            .bind(with: self) { owner, _ in
                owner.scrollToNext.accept(Void())
            }
            .disposed(by: disposeBag)

        isNextOk
            .filter { !$0 }
            .bind(with: self) { owner, _ in
                localError.accept("비밀번호를 확인해주세요.")
            }
            .disposed(by: disposeBag)

        input.prevButtonTapped
            .bind(with: self) { owner, void in
                owner.scrollToPrev.accept(void)
            }
            .disposed(by: disposeBag)

        return Output(
            comparisonResult: comparisonResult,
            hideSameErrorLabel: hideSameErrorLabel,
            localError: localError
        )
    }

    private func isValidPassword(_ password: String) -> Bool {
        let regex = "^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[!@#$%^&*()_+=-]).{8,50}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: password)
    }

}
