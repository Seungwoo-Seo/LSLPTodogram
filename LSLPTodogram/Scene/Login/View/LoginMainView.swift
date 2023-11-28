//
//  LoginMainView.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/11/20.
//

import UIKit

final class LoginMainView: BaseView {
    private let iconImageView = {
        let view = UIImageView(image: UIImage(named: "fire.png"))
        view.contentMode = .scaleAspectFit
        return view
    }()
    let emailTextField = InfoInputTextField(placeholder: "이메일을 입력해주세요.")
    let passwordTextField = InfoInputTextField(placeholder: "비밀번호를 입력해주세요.")
    let loginButton = InfoInputButton(title: "로그인")
    let joinButton = InfoInputButton(title: "새 계정 만들기")

    override func initialAttributes() {
        super.initialAttributes()

        let passwordButton = UIButton()
        passwordButton.setImage(UIImage(systemName: "eye"), for: .normal)
        passwordButton.setImage(UIImage(systemName: "eye.fill"), for: .selected)
        passwordButton.addTarget(self, action: #selector(didTapButtonPassword), for: .touchUpInside)

        passwordTextField.rightViewMode = .always
        passwordTextField.rightView = passwordButton
        passwordTextField.isSecureTextEntry = true
    }

    override func initialHierarchy() {
        super.initialHierarchy()

        [
            iconImageView,
            emailTextField,
            passwordTextField,
            loginButton,
            joinButton
        ].forEach { addSubview($0) }
    }

    override func initialLayout() {
        super.initialLayout()

        let offset = 16
        let inset = 16
        let height = 44
        iconImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(emailTextField.snp.top).offset(-offset)
        }
        emailTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(inset)
            make.bottom.equalTo(passwordTextField.snp.top).offset(-offset)
            make.height.equalTo(height)
        }

        passwordTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(inset)
            make.centerY.equalToSuperview()
            make.height.equalTo(height)
        }

        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(offset)
            make.horizontalEdges.equalToSuperview().inset(inset)
            make.height.equalTo(height)
        }

        joinButton.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(offset)
            make.horizontalEdges.equalToSuperview().inset(inset)
            make.height.equalTo(height)
        }
    }

}

private extension LoginMainView {

    @objc
    func didTapButtonPassword(_ sender: UIButton) {
        sender.isSelected.toggle()
        if sender.isSelected {
            passwordTextField.isSecureTextEntry = false
        } else {
            passwordTextField.isSecureTextEntry = true
        }
    }

}
