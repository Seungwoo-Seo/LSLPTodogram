//
//  PasswordMainView.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/11/23.
//

import UIKit

final class PasswordMainView: BaseView {
    let titleLabel = {
        let view = UILabel()
        view.textColor = Color.black
        view.font = .systemFont(ofSize: 24, weight: .bold)
        view.text = "비밀번호 입력"
        return view
    }()
    let passwordLabel = {
        let view = UILabel()
        view.textColor = Color.black
        view.font = .systemFont(ofSize: 17, weight: .regular)
        view.text = "비밀번호를 입력해주세요."
        return view
    }()
    let passwordTextField = {
        let view = UITextField()
        view.textColor = Color.black
        view.borderStyle = .roundedRect
        return view
    }()
    let sameLabel = {
        let view = UILabel()
        view.textColor = Color.black
        view.font = .systemFont(ofSize: 17, weight: .regular)
        view.text = "비밀번호를 한 번 더 입력해주세요."
        return view
    }()
    let sameTextField = {
        let view = UITextField()
        view.textColor = Color.black
        view.borderStyle = .roundedRect
        return view
    }()
    let nextButton = {
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .capsule
        config.title = "다음"
        let button = UIButton(configuration: config)
        return button
    }()

    override func initialHierarchy() {
        super.initialHierarchy()

        [
            titleLabel,
            passwordLabel,
            passwordTextField,
            sameLabel,
            sameTextField,
            nextButton
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

        passwordLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(offset*2)
            make.horizontalEdges.equalToSuperview().inset(inset)
        }

        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordLabel.snp.bottom).offset(offset/2)
            make.horizontalEdges.equalToSuperview().inset(inset)
            make.height.equalTo(height)
        }

        sameLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(offset*2)
            make.horizontalEdges.equalToSuperview().inset(inset)
        }

        sameTextField.snp.makeConstraints { make in
            make.top.equalTo(sameLabel.snp.bottom).offset(offset/2)
            make.horizontalEdges.equalToSuperview().inset(inset)
            make.height.equalTo(height)
        }

        nextButton.snp.makeConstraints { make in
            make.top.equalTo(sameTextField.snp.bottom).offset(offset*2)
            make.horizontalEdges.equalToSuperview().inset(inset)
            make.height.equalTo(height)
        }
    }


}
