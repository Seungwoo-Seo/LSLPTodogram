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
    let sameStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fillProportionally
        view.spacing = 8
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
    let sameErrorLabel = {
        let view = UILabel()
        view.textColor = Color.red
        view.font = .systemFont(ofSize: 17, weight: .regular)
        view.isHidden = true
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
            sameStackView,
            nextButton
        ].forEach { addSubview($0) }

        [
            sameLabel,
            sameTextField,
            sameErrorLabel
        ].forEach { sameStackView.addArrangedSubview($0) }
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

        sameStackView.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(offset*2)
            make.horizontalEdges.equalToSuperview().inset(inset)
        }

        nextButton.snp.makeConstraints { make in
            make.top.equalTo(sameStackView.snp.bottom).offset(offset*2)
            make.horizontalEdges.equalToSuperview().inset(inset)
            make.height.equalTo(height)
        }
    }

}
