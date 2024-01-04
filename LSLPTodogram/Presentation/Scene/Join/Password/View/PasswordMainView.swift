//
//  PasswordMainView.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/11/23.
//

import UIKit

final class PasswordMainView: BaseView {
    private let titleLabel = InfoInputTitleLabel(text: "비밀번호 입력")
    let passwordView = InfoInputView(description: "비밀번호를 입력해주세요.")
    let reconfirmView = InfoInputView(description: "비밀번호를 한 번 더 입력해주세요.")
    let nextButton = InfoInputButton(title: "다음")
    let prevButton = InfoInputButton(title: "이전")

    override func initialAttributes() {
        super.initialAttributes()

        let passwordButton = UIButton()
        passwordButton.setImage(UIImage(systemName: "eye"), for: .normal)
        passwordButton.setImage(UIImage(systemName: "eye.fill"), for: .selected)
        passwordButton.addTarget(self, action: #selector(didTapButtonPassword), for: .touchUpInside)

        passwordView.textField.rightViewMode = .always
        passwordView.textField.rightView = passwordButton
        passwordView.textField.isSecureTextEntry = true

        let reconfirmButton = UIButton()
        reconfirmButton.setImage(UIImage(systemName: "eye"), for: .normal)
        reconfirmButton.setImage(UIImage(systemName: "eye.fill"), for: .selected)
        reconfirmButton.addTarget(self, action: #selector(didTapButtonReconfirm), for: .touchUpInside)
        
        reconfirmView.textField.rightViewMode = .always
        reconfirmView.textField.rightView = reconfirmButton
        reconfirmView.textField.isSecureTextEntry = true
    }

    override func initialHierarchy() {
        super.initialHierarchy()

        [
            titleLabel,
            passwordView,
            reconfirmView,
            nextButton,
            prevButton
        ].forEach { addSubview($0) }
    }

    override func initialLayout() {
        super.initialLayout()

        let offset = 16
        let inset = 16
        let height = 44
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(inset)
            make.horizontalEdges.equalToSuperview().inset(inset)
        }

        passwordView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(offset*2)
            make.horizontalEdges.equalToSuperview().inset(inset)
        }

        reconfirmView.snp.makeConstraints { make in
            make.top.equalTo(passwordView.snp.bottom).offset(offset)
            make.horizontalEdges.equalToSuperview().inset(inset)
        }

        nextButton.snp.makeConstraints { make in
            make.top.equalTo(reconfirmView.snp.bottom).offset(offset*2)
            make.horizontalEdges.equalToSuperview().inset(inset)
            make.height.equalTo(height)
        }

        prevButton.snp.makeConstraints { make in
            make.top.equalTo(nextButton.snp.bottom).offset(offset)
            make.horizontalEdges.equalToSuperview().inset(inset)
            make.height.equalTo(height)
        }
    }

}

private extension PasswordMainView {

    @objc
    func didTapButtonPassword(_ sender: UIButton) {
        sender.isSelected.toggle()
        if sender.isSelected {
            passwordView.textField.isSecureTextEntry = false
        } else {
            passwordView.textField.isSecureTextEntry = true
        }
    }

    @objc
    func didTapButtonReconfirm(_ sender: UIButton) {
        sender.isSelected.toggle()
        if sender.isSelected {
            reconfirmView.textField.isSecureTextEntry = false
        } else {
            reconfirmView.textField.isSecureTextEntry = true
        }
    }

}
