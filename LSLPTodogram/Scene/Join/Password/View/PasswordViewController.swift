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
            passwordText: mainView.passwordView.textField.rx.text,
            sameText: mainView.reconfirmView.textField.rx.text,
            nextButtonTapped: mainView.nextButton.rx.tap,
            prevButtonTapped: mainView.prevButton.rx.tap
        )

        let output = viewModel.transform(input: input)

        output.comparisonResult
            .bind(with: self) { owner, bool in
                owner.mainView.reconfirmView.errorLabel.isHidden = false
                owner.mainView.reconfirmView.errorLabel.textColor = bool ? Color.green : Color.red
                owner.mainView.reconfirmView.errorLabel.text = bool ? "비밀번호가 같습니다." : "비밀번호가 다릅니다."
            }
            .disposed(by: disposeBag)

        output.hideSameErrorLabel
            .bind(to: mainView.reconfirmView.errorLabel.rx.isHidden)
            .disposed(by: disposeBag)

        output.localError
            .bind(with: self) { owner, errorString in
                owner.presentAlert(title: errorString)
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
