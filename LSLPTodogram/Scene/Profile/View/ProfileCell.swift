//
//  ProfileCell.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/11.
//

import UIKit

final class ProfileCell: BaseTableViewCell {
    let labelStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fillProportionally
        view.spacing = 8
        return view
    }()
    let nicknameLabel = NicknameLabel(fontSize: 24, weight: .bold)
    let emailLabel = {
        let label = UILabel()
        label.textColor = Color.black
        label.font = .systemFont(ofSize: 15, weight: .semibold)

        return label
    }()
    let profileImageView = ProfileImageView(image: UIImage(systemName: "person"))

    private let fButtonStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .fillProportionally
        view.spacing = 0
        return view
    }()
    let followersButton = FollowersButton()
    let followingButton = FollowingButton()

    private let pButtonStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.alignment = .fill
        view.spacing = 16
        return view
    }()
    let profileEditButton = {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = Color.black
        config.background.backgroundColor = Color.clear
        config.background.strokeColor = Color.black
        config.background.strokeWidth = 1
        config.cornerStyle = .medium
        config.title = "프로필 편집"
        let button = UIButton(configuration: config)
        return button
    }()
    let profileShareButton = {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = Color.black
        config.background.backgroundColor = Color.clear
        config.background.strokeColor = Color.black
        config.background.strokeWidth = 1
        config.cornerStyle = .medium
        config.title = "프로필 공유"
        let button = UIButton(configuration: config)
        return button
    }()

    func configure(_ item: Profile) {
        profileImageView.image = UIImage(systemName: "person")
        nicknameLabel.text = item.nick
        emailLabel.text = item.email
        followersButton.configuration?.title = "팔로워 \(item.followers.count)명"
        followingButton.configuration?.title = "팔로잉 \(item.following.count)명"
    }

    override func initialHierarchy() {
        super.initialHierarchy()

        [

            labelStackView,
            profileImageView,
            fButtonStackView,
            pButtonStackView
        ].forEach { contentView.addSubview($0) }

        [nicknameLabel, emailLabel].forEach { labelStackView.addArrangedSubview($0) }

        [followersButton, followingButton].forEach { fButtonStackView.addArrangedSubview($0) }

        [profileEditButton, profileShareButton].forEach { pButtonStackView.addArrangedSubview($0) }
    }

    override func initialLayout() {
        super.initialLayout()

        let offset = 16
        let inset = 16
        let height = 44
        labelStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(inset)
            make.centerY.equalTo(profileImageView)
        }

        profileImageView.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(inset)
            make.leading.equalTo(labelStackView.snp.trailing).offset(offset)
            make.size.equalTo(labelStackView.snp.height)
        }

        fButtonStackView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(offset)
            make.leading.equalToSuperview()
            make.trailing.lessThanOrEqualToSuperview().inset(inset)
            make.height.equalTo(height)
        }

        pButtonStackView.snp.makeConstraints { make in
            make.top.equalTo(fButtonStackView.snp.bottom).offset(offset)
            make.horizontalEdges.bottom.equalToSuperview().inset(inset)
            make.height.equalTo(height)
        }
    }
}
