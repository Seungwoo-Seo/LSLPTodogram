//
//  InfoInputView.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/11/23.
//

import UIKit

final class InfoInputView: BaseView {
    private let stackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fillProportionally
        view.spacing = 8
        return view
    }()
    let descriptionLabel = {
        let view = UILabel()
        view.textColor = Color.black
        view.font = .systemFont(ofSize: 17, weight: .regular)
        return view
    }()
    let textField = {
        let view = UITextField()
        view.textColor = Color.black
        view.borderStyle = .roundedRect
        return view
    }()
    let errorLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 17, weight: .regular)
        view.isHidden = true
        return view
    }()

    convenience init(description: String?) {
        self.init(frame: .zero)
        self.descriptionLabel.text = description
    }

    override func initialHierarchy() {
        super.initialHierarchy()

        addSubview(stackView)

        [
            descriptionLabel,
            textField,
            errorLabel
        ].forEach { stackView.addArrangedSubview($0) }
    }

    override func initialLayout() {
        super.initialLayout()

        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        textField.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
    }

}
