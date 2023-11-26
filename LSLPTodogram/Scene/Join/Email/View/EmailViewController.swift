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

    init(viewModel: EmailViewModel) {
        super.init(nibName: nil, bundle: nil)

        let input = EmailViewModel.Input(
            emailText: mainView.textField.rx.controlEvent(.editingChanged)
                .withLatestFrom(mainView.textField.rx.text.orEmpty),
            validationButtonTapped: mainView.validationButton.rx.tap,
            nextButtonTapped: mainView.nextButton.rx.tap
        )

        let output = viewModel.transform(input: input)
        output.emailState
            .bind(with: self) { owner, result in
                switch result {
                case .success(let success):
                    switch success {
                    case .available:
                        owner.mainView.errorLabel.isHidden = true
                    case .duplicatePass:
                        owner.mainView.errorLabel.text = success.description
                        owner.mainView.errorLabel.isHidden = false
                        owner.mainView.errorLabel.textColor = Color.green
                    }
                case .failure(let error):
                    owner.mainView.errorLabel.text = error.description
                    owner.mainView.errorLabel.isHidden = false
                    owner.mainView.errorLabel.textColor = Color.red
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

}
