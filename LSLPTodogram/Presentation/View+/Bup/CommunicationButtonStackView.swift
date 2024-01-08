//
//  CommunicationButtonStackView.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/24.
//

import UIKit

final class CommunicationButtonStackView: BaseStackView {
    let likeButton = CommunicationButton(style: .like)
    let commentButton = CommunicationButton(style: .comment)
    let repostButton = CommunicationButton(style: .repost)
    let shareButton = CommunicationButton(style: .share)

    override func initialAttributes() {
        super.initialAttributes()

        axis = .horizontal
        alignment = .fill
        distribution = .fillEqually
        spacing = 16
    }

    override func initialHierarchy() {
        super.initialHierarchy()

        [
            likeButton,
            commentButton,
            repostButton,
            shareButton
        ].forEach { addArrangedSubview($0) }
    }

    override func initialLayout() {
        super.initialLayout()

        snp.makeConstraints { make in
            make.width.equalTo(137.33)
            make.height.equalTo(22)
        }
    }
}
