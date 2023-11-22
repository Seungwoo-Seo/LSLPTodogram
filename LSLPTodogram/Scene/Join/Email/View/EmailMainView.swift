//
//  EmailMainView.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/11/22.
//

import UIKit

final class EmailMainView: BaseView {
    let titleLabel = {
        let view = UILabel()
        view.textColor = Color.black
        view.font = .systemFont(ofSize: 24, weight: .bold)
        view.text = "이메일 입력"
        return view
    }()
    let subTitleLabel = {
        let view = UILabel()
        view.textColor = Color.black
        view.font = .systemFont(ofSize: 17, weight: .regular)
        view.text = "이메일을 입력해보세요."
        return view
    }()
    let emailTextField = {
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
            subTitleLabel,
            emailTextField,
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

        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(offset/2)
            make.horizontalEdges.equalToSuperview().inset(inset)
        }

        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(offset+4)
            make.horizontalEdges.equalToSuperview().inset(inset)
            make.height.equalTo(height)
        }

        nextButton.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(offset)
            make.horizontalEdges.equalToSuperview().inset(inset)
            make.height.equalTo(height)
        }
    }

}
