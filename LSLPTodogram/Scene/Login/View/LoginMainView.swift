//
//  LoginMainView.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/11/20.
//

import UIKit

final class LoginMainView: BaseView {
    let iconImageView = {
        let view = UIImageView(image: UIImage(named: "fire.png"))
        view.contentMode = .scaleAspectFit
        return view
    }()
    let emailTextField = {
        let view = UITextField()
        view.borderStyle = .roundedRect
        view.placeholder = "이메일을 입력해주세요."
        view.textColor = .black
        return view
    }()
    let passwordTextField = {
        let view = UITextField()
        view.borderStyle = .roundedRect
        view.placeholder = "비밀번호를 입력해주세요."
        view.textColor = .black
        return view
    }()
    let loginButton = {
        var config = UIButton.Configuration.filled()
        config.background.backgroundColor = Color.red
        config.cornerStyle = .capsule
        config.title = "로그인"
        let button = UIButton(configuration: config)
        return button
    }()
    let joinButton = {
        var config = UIButton.Configuration.filled()
        config.background.backgroundColor = Color.red
        config.cornerStyle = .capsule
        config.title = "새 계정 만들기"
        let button = UIButton(configuration: config)
        return button
    }()

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
//            make.bottom.equalTo(safeAreaLayoutGuide)
            make.top.equalTo(loginButton.snp.bottom).offset(offset)
            make.horizontalEdges.equalToSuperview().inset(inset)
            make.height.equalTo(height)
        }
    }

}
