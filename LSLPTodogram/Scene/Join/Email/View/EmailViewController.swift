//
//  EmailViewController.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/11/22.
//

import UIKit
import RxCocoa
import RxSwift

final class EmailViewController: BaseViewController {
    private let mainView = EmailMainView()

    private let disposeBag = DisposeBag()
    private let viewModel = EmailViewModel()

    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bind()
    }

    private func bind() {
        let input = EmailViewModel.Input(
            emailText: mainView.emailTextField.rx.text,
            emailValidationButtonTapped: mainView.emailValidationButton.rx.tap,
            nextButtonTapped: mainView.nextButton.rx.tap
        )

        let output = viewModel.transform(input: input)
        output.localError
            .bind(with: self) { owner, localError in
                owner.presentAlert(title: localError)
            }
            .disposed(by: disposeBag)

        output.emailValidationError
            .bind(with: self) { owner, emailValidationError in
                owner.presentAlert(title: emailValidationError.description)
            }
            .disposed(by: disposeBag)

        output.emailSuccessMessage
            .bind(with: self) { owner, message in
                owner.presentAlert(title: message)
            }
            .disposed(by: disposeBag)
    }

    private func presentAlert(title: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .default)
        alert.addAction(confirm)
        present(alert, animated: true)
    }

}
