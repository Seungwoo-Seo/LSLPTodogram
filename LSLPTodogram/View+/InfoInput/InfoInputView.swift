//
//  InfoInputView.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/11/23.
//

import UIKit

final class InfoInputView: BaseView {
    private let descriptionLabel = InfoInputDescriptionLabel(text: nil)
    private let stackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fillProportionally
        view.spacing = 4
        return view
    }()
    let textField = InfoInputTextField()
    let errorLabel = ErrorLabel()

    init(description: String?, placeholder: String? = nil) {
        super.init(frame: .zero)
        self.descriptionLabel.text = description
        self.textField.placeholder = placeholder
    }

    override func initialHierarchy() {
        super.initialHierarchy()

        [
            descriptionLabel,
            stackView
        ].forEach { addSubview($0) }

        [
            textField,
            errorLabel
        ].forEach { stackView.addArrangedSubview($0) }
    }

    override func initialLayout() {
        super.initialLayout()

        descriptionLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }

        stackView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(8)
            make.horizontalEdges.bottom.equalToSuperview()
        }

        textField.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
    }

}
