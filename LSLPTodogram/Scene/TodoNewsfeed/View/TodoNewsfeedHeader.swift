//
//  TodoNewsfeedHeader.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/11/30.
//

import UIKit

final class TodoNewsfeedHeader: BaseCollectionReusableView {
    private let hStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .top
        view.distribution = .fill
        view.spacing = 16
        return view
    }()
    let profileImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    private let labelStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .top
        view.distribution = .equalSpacing
        view.spacing = 4
        return view
    }()
    let nicknameLabel = {
        let label = UILabel()
        label.textColor = Color.black
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        return label
    }()
    let titleLabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = Color.black
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        return label
    }()

    override func initialHierarchy() {
        super.initialHierarchy()

        addSubview(hStackView)

        [
            profileImageView,
            labelStackView
        ].forEach { hStackView.addArrangedSubview($0) }

        [
            nicknameLabel,
            titleLabel
        ].forEach { labelStackView.addArrangedSubview($0) }
    }

    override func initialLayout() {
        super.initialLayout()

        let inset = 16
        hStackView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(inset)
            make.bottom.equalToSuperview()
        }

        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(44)
        }
    }

}
