//
//  FollowerListCell.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2024/01/09.
//

import UIKit
import RxSwift

final class FollowerListCell: BaseTableViewCell {
    var disposeBag = DisposeBag()

    let profileImageButton = ProfileImageButton()
    let profileNicknameButton = ProfileNicknameButton()

    func configure(_ item: Follower) {
//        item.nick
//        item.profileImageString
        profileImageButton.updateImage(image: UIImage(named: "profile"))
        profileNicknameButton.updateTitle(title: item.nick)
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        disposeBag = DisposeBag()
    }

    override func initialHierarchy() {
        super.initialHierarchy()

        [
            profileImageButton,
            profileNicknameButton
        ].forEach { contentView.addSubview($0) }
    }

    override func initialLayout() {
        super.initialLayout()

        let offset = 16
        let inset = 16
        let height = 44
        profileImageButton.snp.makeConstraints { make in
            make.verticalEdges.leading.equalToSuperview().inset(inset)
        }

        profileNicknameButton.snp.makeConstraints { make in
            make.centerY.equalTo(profileImageButton.snp.centerY)
            make.leading.equalTo(profileImageButton.snp.trailing).offset(offset)
            make.trailing.lessThanOrEqualToSuperview().inset(inset)
        }
    }
}
