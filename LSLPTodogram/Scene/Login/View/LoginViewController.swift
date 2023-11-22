//
//  LoginViewController.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/11/20.
//

import UIKit
import RxCocoa
import RxSwift

final class LoginViewController: BaseViewController {
    private let mainView = LoginMainView()

    private let disposeBag = DisposeBag()
    private let viewModel = LoginViewModel()

    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bind()
    }

    private func bind() {
        let input = LoginViewModel.Input(
            email: mainView.emailTextField.rx.text,
            password: mainView.passwordTextField.rx.text,
            loginButtonTapped: mainView.loginButton.rx.tap
        )
        let output = viewModel.transform(input: input)

        output.loginErrorDescription
            .bind(with: self) { owner, description in
                owner.presentError(title: description)
            }
            .disposed(by: disposeBag)
    }

    private func presentError(title: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .default)
        alert.addAction(confirm)
        present(alert, animated: true)
    }

}
