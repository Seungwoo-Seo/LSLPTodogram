//
//  BupInfoView.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/12.
//

import UIKit

final class BupInfoView: BaseView {
    private let hStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .top
        view.distribution = .fill
        view.spacing = 16
        return view
    }()
    let profileImageView = ProfileImageView(image: UIImage(systemName: "person.fill"))
    private let labelStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .top
        view.distribution = .equalSpacing
        view.spacing = 4
        return view
    }()
    let nicknameLabel = NicknameLabel()
    let phoneNumLabel = NicknameLabel()
    let titleLabel = BupTitleLabel()

    override func initialAttributes() {
        super.initialAttributes()

        backgroundColor = Color.green
        layer.cornerRadius = 16
        clipsToBounds = true
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }

    override func initialHierarchy() {
        super.initialHierarchy()

        [
            hStackView,
            titleLabel
        ].forEach { addSubview($0) }

        [
            profileImageView,
            labelStackView
        ].forEach { hStackView.addArrangedSubview($0) }

        [
            nicknameLabel,
            phoneNumLabel
        ].forEach { labelStackView.addArrangedSubview($0) }
    }

    override func initialLayout() {
        super.initialLayout()

        let offset = 16
        let inset = 16
        hStackView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(inset)
        }

        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(40)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(offset)
            make.horizontalEdges.bottom.equalToSuperview().inset(inset)
        }
    }

}
