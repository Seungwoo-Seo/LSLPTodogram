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

    init(_ viewModel: LoginViewModel) {
        super.init(nibName: nil, bundle: nil)

        let input = LoginViewModel.Input(
            email: mainView.emailTextField.rx.text,
            password: mainView.passwordTextField.rx.text,
            loginButtonTapped: mainView.loginButton.rx.tap,
            joinButtonTapped: mainView.joinButton.rx.tap
        )
        let output = viewModel.transform(input: input)

        output.loginErrorDescription
            .bind(with: self) { owner, description in
                owner.presentError(title: description)
            }
            .disposed(by: disposeBag)

        output.pushToJoin
            .bind(with: self) { owner, _ in
                let vc = JoinTabViewController(viewModel: JoinViewModel())
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }

    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func initialAttributes() {
        super.initialAttributes()

        navigationController?.navigationBar.tintColor = Color.red
        navigationItem.hidesBackButton = true
    }

    private func presentError(title: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .default)
        alert.addAction(confirm)
        present(alert, animated: true)
    }

}
