//
//  ProfileEditViewController.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/15.
//

import UIKit
import RxCocoa
import RxSwift

final class ProfileEditViewController: BaseViewController {
    private let disposeBag = DisposeBag()

    private let cancelBarButtonItem = {
        let item = UIBarButtonItem()
        item.title = "취소"
        item.style = .plain
        return item
    }()
    private let completeBarButtonItem = {
        let item = UIBarButtonItem()
        item.title = "완료"
        item.style = .plain
        item.tintColor = Color.systemBlue
        return item
    }()
    private let mainView = ProfileEditMainView()

    private let viewModel: ProfileEditViewModel

    init(_ viewModel: ProfileEditViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        let input = ProfileEditViewModel.Input(
            nicknameText: mainView.nicknameView.textField.rx.text.orEmpty,
            phoneNumText: mainView.phoneNumView.textField.rx.text.orEmpty,
            birthDayText: mainView.birthDayView.textField.rx.text.orEmpty,
            birthDayDate: mainView.datePicker.rx.date,
            cancelBarButtonItemTapped: cancelBarButtonItem.rx.tap,
            completeBarButtonItemTapped: completeBarButtonItem.rx.tap
        )
        let output = viewModel.transform(input: input)
        output.isProfile
            .bind(with: self) { owner, profile in
                owner.mainView.nicknameView.textField.placeholder = profile.nick
                owner.mainView.phoneNumView.textField.placeholder = profile.phoneNum ?? "없음"
                owner.mainView.birthDayView.textField.placeholder = profile.birthDay ?? "없음"
            }
            .disposed(by: disposeBag)

        output.nicknameState
            .bind(with: self) { owner, result in
                switch result {
                case .success:
                    owner.mainView.nicknameView.errorLabel.isHidden = true
                case .failure(let error):
                    switch error {
                    case .empty:
                        owner.mainView.nicknameView.errorLabel.isHidden = true
                    default:
                        owner.mainView.nicknameView.errorLabel.text = error.description
                        owner.mainView.nicknameView.errorLabel.isHidden = false
                        owner.mainView.nicknameView.errorLabel.textColor = Color.red
                    }
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

        output.completeState
            .bind(with: self) { owner, result in
                switch result {
                case .success:
                    owner.unwind()

                case .failure:
                    owner.presentErrorAlert()
                }
            }
            .disposed(by: disposeBag)

        output.cancelState
            .bind(with: self) { owner, bool in
                if bool {
                    owner.unwind()
                } else {
                    owner.presentCancelAlert()
                }
            }
            .disposed(by: disposeBag)

        output.npb
            .bind(to: self.rx.isModalInPresentation)
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

        navigationItem.title = "프로필 편집"
    }

    override func initialHierarchy() {
        super.initialHierarchy()

        navigationItem.leftBarButtonItem = cancelBarButtonItem
        navigationItem.rightBarButtonItem = completeBarButtonItem
    }

}

private extension ProfileEditViewController {

    func unwind() {
        dismiss(animated: true)
    }

    func presentErrorAlert() {
        let alert = UIAlertController(title: "에러를 확인해주세요.", message: nil, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .default)
        alert.addAction(confirm)
        present(alert, animated: true)
    }

    func presentCancelAlert() {
        let alert = UIAlertController(
            title: "편집 내용을 삭제하시겠어요?",
            message: nil,
            preferredStyle: .alert
        )

        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let remove = UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
            guard let self else {return}
            self.unwind()
        }
        [cancel, remove].forEach { alert.addAction($0) }

        present(alert, animated: true)
    }

}
