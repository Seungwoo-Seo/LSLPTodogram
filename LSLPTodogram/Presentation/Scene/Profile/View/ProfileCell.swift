//
//  ProfileCell.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/11.
//

import UIKit
import RxSwift

final class ProfileCell: BaseTableViewCell {
    var disposeBag = DisposeBag()

    let profileNicknameButton = ProfileNicknameButton(size: 24)
    let emailLabel = {
        let label = UILabel()
        label.textColor = Color.black
        label.font = .systemFont(ofSize: 15, weight: .semibold)

        return label
    }()
    let profileImageButton = ProfileImageButton(size: CGSize(width: 60, height: 60))

    private lazy var fButtonStackView = {
        let view = UIStackView(arrangedSubviews: [followersButton, followingButton])
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .fillProportionally
        view.spacing = 16
        return view
    }()
    let followersButton = FollowersButton()
    let followingButton = FollowingButton()

    private lazy var pButtonStackView = {
        let view = UIStackView(arrangedSubviews: [profileEditButton, profileShareButton])
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
        if let imageString = item.profileImageString {
            profileImageButton.imageView?.requestModifier(with: imageString) { [weak self] (image) in
                guard let self else {return}
                self.profileImageButton.updateImage(image: image)
            }
        } else {
            profileImageButton.updateImage(image: UIImage(named: "profile"))
        }
        profileNicknameButton.updateTitle(title: item.nick)
        emailLabel.text = item.email
        followersButton.configuration?.title = "팔로워 \(item.followers?.count ?? 0)명"
        followingButton.configuration?.title = "팔로잉 \(item.following?.count ?? 0)명"
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        disposeBag = DisposeBag()
    }

    override func initialHierarchy() {
        super.initialHierarchy()

        [
            profileNicknameButton,
            profileImageButton,
            emailLabel,
            fButtonStackView,
            pButtonStackView
        ].forEach { contentView.addSubview($0) }
    }

    override func initialLayout() {
        super.initialLayout()

        let offset = 16
        let inset = 16
        let height = 44
        profileNicknameButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(inset)
            make.leading.equalToSuperview().inset(inset)
            make.trailing.lessThanOrEqualTo(profileImageButton.snp.leading).offset(-offset)
        }

        profileImageButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(inset)
//            make.size.equalTo(60)
        }

        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(profileNicknameButton.snp.bottom).offset(4)
            make.leading.equalToSuperview().inset(inset)
            make.trailing.lessThanOrEqualTo(profileImageButton.snp.leading).offset(-offset)
        }

        fButtonStackView.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(offset)
            make.leading.equalToSuperview().inset(inset)
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
