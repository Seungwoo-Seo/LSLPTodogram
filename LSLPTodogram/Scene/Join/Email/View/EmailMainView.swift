//
//  EmailMainView.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/11/22.
//

import UIKit

final class EmailMainView: BaseView {
    private let titleLabel = InfoInputTitleLabel(text: "이메일 입력")
    private let descriptionLabel = InfoInputDescriptionLabel(text: "이메일을 입력해주세요.")
    private let horizontalStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = 16
        return view
    }()
    let textField = InfoInputTextField()
    let validationButton = InfoInputButton(title: "확인", cornerStyle: .large)
    private let verticalStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fillProportionally
        view.spacing = 4
        return view
    }()
    let errorLabel = ErrorLabel()
    let nextButton = InfoInputButton(title: "다음")

    override func initialHierarchy() {
        super.initialHierarchy()

        [
            titleLabel,
            descriptionLabel,
            verticalStackView,
            nextButton
        ].forEach { addSubview($0) }

        [
            textField,
            validationButton
        ].forEach { horizontalStackView.addArrangedSubview($0) }

        [
            horizontalStackView,
            errorLabel
        ].forEach { verticalStackView.addArrangedSubview($0) }
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

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(offset*2)
            make.horizontalEdges.equalToSuperview().inset(inset)
        }

        verticalStackView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(offset/2)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(inset)
        }

        validationButton.snp.makeConstraints { make in
            make.height.equalTo(height)
        }

        nextButton.snp.makeConstraints { make in
            make.top.equalTo(verticalStackView.snp.bottom).offset(offset*2)
            make.horizontalEdges.equalToSuperview().inset(inset)
            make.height.equalTo(height)
        }
    }

}
