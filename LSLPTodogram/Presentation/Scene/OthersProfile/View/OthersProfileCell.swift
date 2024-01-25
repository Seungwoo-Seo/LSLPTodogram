//
//  OthersProfileCell.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/20.
//

import UIKit
import RxSwift

final class OthersProfileCell: BaseTableViewCell {
    var disposeBag = DisposeBag()

    let profileNicknameButton = ProfileNicknameButton(size: 24)
    let profileImageButton = ProfileImageButton(size: CGSize(width: 60, height: 60))

    private lazy var fButtonStackView = {
        let view = UIStackView(arrangedSubviews: [followersButton, followingButton])
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .fillEqually
        view.spacing = 16
        return view
    }()
    let followersButton = FollowersButton()
    let followingButton = FollowingButton()

    let followButton = {
        var config = UIButton.Configuration.plain()

        config.cornerStyle = .medium
        let button = UIButton(configuration: config)
        button.configurationUpdateHandler = { button in
            switch button.state {
            case .selected:
                button.configuration?.title = "팔로잉"
                button.configuration?.baseForegroundColor = Color.black
                button.configuration?.background.backgroundColor = Color.white
                button.configuration?.background.strokeColor = Color.black
                button.configuration?.background.strokeWidth = 1
            default:
                button.configuration?.title = "팔로우"
                button.configuration?.baseForegroundColor = Color.white
                button.configuration?.background.backgroundColor = Color.black
                button.configuration?.background.strokeWidth = 0
            }
        }
        return button
    }()

    func configure(_ item: OthersProfile) {
        if let imageString = item.profileImageString {
            profileImageButton.imageView?.requestModifier(with: imageString) { [weak self] (image) in
                guard let self else {return}
                self.profileImageButton.updateImage(image: image)
            }
        } else {
            profileImageButton.updateImage(image: UIImage(named: "profile"))
        }
        profileNicknameButton.updateTitle(title: item.nick)
        followersButton.updateTitle(item.followersCountToString())
        followingButton.updateTitle(item.followingCountToString())
        followButton.isSelected = item.followStateToBool()
        followButton.configuration?.title = item.followStateToString()
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
            fButtonStackView,
            followButton
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
        }

        fButtonStackView.snp.makeConstraints { make in
            make.top.equalTo(profileImageButton.snp.bottom).offset(offset)
            make.leading.equalToSuperview().inset(inset)
            make.trailing.lessThanOrEqualToSuperview().inset(inset)
            make.height.equalTo(height)
        }

        followButton.snp.makeConstraints { make in
            make.top.equalTo(fButtonStackView.snp.bottom).offset(offset)
            make.horizontalEdges.bottom.equalToSuperview().inset(inset)
            make.height.equalTo(height)
        }
    }
}
