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

    init(viewModel: UserDetailViewModel) {
        super.init(nibName: nil, bundle: nil)

        let input = UserDetailViewModel.Input(
            nicknameText: mainView.nicknameView.textField.rx.text,
            phoneNumText: mainView.phoneNumView.textField.rx.text,
            birthDayText: mainView.birthDayView.textField.rx.text,
            birthDayDate: mainView.datePicker.rx.date,
            joinButtonTapped: mainView.joinButton.rx.tap,
            prevButtonTapped: mainView.prevButton.rx.tap
        )

        let output = viewModel.transform(input: input)
        output.nicknameState
            .bind(with: self) { owner, result in
                switch result {
                case .success:
                    owner.mainView.nicknameView.errorLabel.isHidden = true
                case .failure(let error):
                    owner.mainView.nicknameView.errorLabel.text = error.description
                    owner.mainView.nicknameView.errorLabel.isHidden = false
                    owner.mainView.nicknameView.errorLabel.textColor = Color.red
                }
            }
            .disposed(by: disposeBag)

        output.phoneNumState
            .bind(with: self) { owner, result in
                switch result {
                case .success:
                    owner.mainView.phoneNumView.errorLabel.isHidden = true
                case .failure(let error):
                    switch error {
                    case .empty:    // 에러로 처리했을 뿐 에러는 아님 => phoneNum는 선택사항이기 때문에!
                        owner.mainView.phoneNumView.errorLabel.isHidden = true
                    default:
                        owner.mainView.phoneNumView.errorLabel.text = error.description
                        owner.mainView.phoneNumView.errorLabel.isHidden = false
                        owner.mainView.phoneNumView.errorLabel.textColor = Color.red
                    }
                }
            }
            .disposed(by: disposeBag)

        output.birthDayState
            .bind(with: self) { owner, result in
                switch result {
                case .success:
                    owner.mainView.birthDayView.errorLabel.isHidden = true
                case .failure(let error):
                    switch error {
                    case .empty: // 에러로 처리했을 뿐 에러는 아님 => birthDay는 선택사항이기 때문에!
                        owner.mainView.birthDayView.errorLabel.isHidden = true
                    default:
                        owner.mainView.birthDayView.errorLabel.text = error.description
                        owner.mainView.birthDayView.errorLabel.isHidden = false
                        owner.mainView.birthDayView.errorLabel.textColor = Color.red
                    }
                }
            }
            .disposed(by: disposeBag)

        output.windowReset
            .bind(to: rx.windowReset)
            .disposed(by: disposeBag)
    }

    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

}

private extension Reactive where Base: UserDetailViewController {

    var windowReset: Binder<Void> {
        return Binder(base) { (_, _) in
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            let sceneDelegate = windowScene?.delegate as? SceneDelegate
            sceneDelegate?.window?.rootViewController = LoginViewController()
            sceneDelegate?.window?.makeKeyAndVisible()
        }
    }

}
