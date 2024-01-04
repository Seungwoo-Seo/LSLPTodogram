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

    let nicknameLabel = NicknameLabel(fontSize: 24, weight: .bold)
    let profileImageView = ProfileImageView(image: UIImage(systemName: "person"))

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
        profileImageView.image = UIImage(systemName: "person")
        nicknameLabel.text = item.nick
        
        followersButton.configuration?.title = "팔로워 \(item.followers?.count ?? 0)명"
        followingButton.configuration?.title = "팔로잉 \(item.following?.count ?? 0)명"

        // 이 사람 팔로워 목록에 내가 아이디가 있다면 true
        // 없다면 false
        if let followers = item.followers {
            print("followers =====> ", followers)
            print("myId =====> ", item.myId)
            let isSelected = followers.contains(where: { $0.id == item.myId })
            print("---->", isSelected)
            followButton.isSelected = isSelected
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        disposeBag = DisposeBag()
    }

    override func initialHierarchy() {
        super.initialHierarchy()

        [
            nicknameLabel,
            profileImageView,
            fButtonStackView,
            followButton
        ].forEach { contentView.addSubview($0) }
    }

    override func initialLayout() {
        super.initialLayout()

        let offset = 16
        let inset = 16
        let height = 44
        nicknameLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(inset)
        }

        profileImageView.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(inset)
            make.leading.equalTo(nicknameLabel.snp.trailing).offset(offset)
            make.size.equalTo(50)
        }

        fButtonStackView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(offset)
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
