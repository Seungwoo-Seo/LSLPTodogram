//
//  PasswordViewController.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/11/23.
//

import UIKit
import RxCocoa
import RxSwift

final class PasswordViewController: BaseViewController {
    private let mainView = PasswordMainView()

    private let disposeBag = DisposeBag()
    private let viewModel = PasswordViewModel()

    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bind()
    }

    private func bind() {
        let input = PasswordViewModel.Input(
            passwordText: mainView.passwordTextField.rx.text,
            sameText: mainView.sameTextField.rx.text
        )

        let output = viewModel.transform(input: input)

        output.comparisonResult
            .bind(with: self) { owner, bool in
                owner.mainView.sameErrorLabel.isHidden = false
                owner.mainView.sameErrorLabel.textColor = bool ? Color.green : Color.red
                owner.mainView.sameErrorLabel.text = bool ? "비밀번호가 같습니다." : "비밀번호가 다릅니다."
            }
            .disposed(by: disposeBag)

        output.hideSameErrorLabel
            .bind(to: mainView.sameErrorLabel.rx.isHidden)
            .disposed(by: disposeBag)
    }

}
