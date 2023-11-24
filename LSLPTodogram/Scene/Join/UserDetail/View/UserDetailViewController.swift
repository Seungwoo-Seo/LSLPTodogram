//
//  UserDetailViewController.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/11/23.
//

import UIKit
import RxCocoa
import RxSwift

final class UserDetailViewController: BaseViewController {
    private let mainView = UserDetailMainView()

    private let disposeBag = DisposeBag()
    private let viewModel = UserDetailViewModel()

    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bind()
    }

    private func bind() {
        let input = UserDetailViewModel.Input(
            nicknameText: mainView.nicknameView.textField.rx.text,
            phoneNubText: mainView.phoneNumView.textField.rx.text,
            birthDayText: mainView.birthDayView.textField.rx.text,
            joinButtonTapped: mainView.completeButton.rx.tap
        )

        let output = viewModel.transform(input: input)
        output.nicknameIsEmpty
            .bind(with: self) { owner, bool in
                owner.mainView.nicknameView.errorLabel.isHidden = false
                owner.mainView.nicknameView.errorLabel.text = bool ? "닉네임 입력은 필수입니다." : ""
                owner.mainView.nicknameView.errorLabel.textColor = bool ? Color.red : Color.green
            }
            .disposed(by: disposeBag)
    }

}
