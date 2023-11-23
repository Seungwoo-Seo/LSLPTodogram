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

    struct Input {
        let passwordText: ControlProperty<String?>
        let sameText: ControlProperty<String?>
    }

    struct Output {
        let comparisonResult: PublishRelay<Bool>
        let hideSameErrorLabel: BehaviorRelay<Bool>
    }

    func transform(input: Input) -> Output {
        let comparisonResult = PublishRelay<Bool>()
        let hideSameErrorLabel = BehaviorRelay(value: true)

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

        return Output(
            comparisonResult: comparisonResult,
            hideSameErrorLabel: hideSameErrorLabel
        )
    }

}
