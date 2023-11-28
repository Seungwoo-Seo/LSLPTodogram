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

    init(viewModel: PasswordViewModel) {
        super.init(nibName: nil, bundle: nil)

        let input = PasswordViewModel.Input(
            passwordText: mainView.passwordView.textField.rx.text.orEmpty.asDriver(),
            reconfirmText: mainView.reconfirmView.textField.rx.text.orEmpty.asDriver(),
            nextButtonTapped: mainView.nextButton.rx.tap,
            prevButtonTapped: mainView.prevButton.rx.tap
        )

        let output = viewModel.transform(input: input)

        output.passwordState
            .debug()
            .bind(with: self) { owner, result in
                switch result {
                case .success(let success):
                    owner.mainView.passwordView.errorLabel.text = success.description
                    owner.mainView.passwordView.errorLabel.isHidden = false
                    owner.mainView.passwordView.errorLabel.textColor = Color.green
                case .failure(let error):
                    switch error {
                    case .never:
                        owner.mainView.passwordView.errorLabel.isHidden = true
                    default:
                        owner.mainView.passwordView.errorLabel.text = error.description
                        owner.mainView.passwordView.errorLabel.isHidden = false
                        owner.mainView.passwordView.errorLabel.textColor = Color.red
                    }
                }
            }
            .disposed(by: disposeBag)

        output.reconfirmState
            .bind(with: self) { owner, result in
                switch result {
                case .success(let success):
                    owner.mainView.reconfirmView.errorLabel.text = success.description
                    owner.mainView.reconfirmView.errorLabel.isHidden = false
                    owner.mainView.reconfirmView.errorLabel.textColor = Color.green
                case .failure(let error):
                    switch error {
                    case .never:
                        owner.mainView.reconfirmView.errorLabel.isHidden = true
                    default:
                        owner.mainView.reconfirmView.errorLabel.text = error.description
                        owner.mainView.reconfirmView.errorLabel.isHidden = false
                        owner.mainView.reconfirmView.errorLabel.textColor = Color.red
                    }
                }
            }
            .disposed(by: disposeBag)
    }

    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    private func presentAlert(title: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .default)
        alert.addAction(confirm)
        present(alert, animated: true)
    }

}
