//
//  BupDetailCommentCell.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2024/01/09.
//

import UIKit
import RxSwift

final class BupDetailCommentCell: BaseTableViewCell {
    let profileImageButton = ProfileImageButton()
    let profileNicknameButton = ProfileNicknameButton()
    let timeLabel = TimeLabel()
    let ellipsisButton = CommunicationButton(style: .ellipsis)
    let contentLabel = ContentLabel()

    func configure(_ item: Comment) {
        if let profileString = item.creator.profile {
            profileImageButton.imageView?.requestModifier(with: profileString) { [weak self] (image) in
                guard let self else {return}
                self.profileImageButton.updateImage(image: image)
            }
        } else {
            profileImageButton.updateImage(image: UIImage(named: "profile"))
        }
        profileNicknameButton.updateTitle(title: item.creator.nick)

        if let difference = calculateTimeDifference(from: item.time) {
            switch difference {
            case .seconds(let seconds):
                timeLabel.text = "\(seconds)초 전"
            case .minutes(let minutes):
                timeLabel.text = "\(minutes)분 전"
            case .hours(let hours):
                timeLabel.text = "\(hours)시간 전"
            case .days(let days):
                timeLabel.text = "\(days)일 전"
            }
        } else {
            timeLabel.text = "Invalid date format"
        }


        contentLabel.text = item.content
    }

    override func initialAttributes() {
        super.initialAttributes()

        backgroundColor = Color.clear
        contentView.backgroundColor = Color.clear
    }

    override func initialHierarchy() {
        super.initialHierarchy()

        [
            profileImageButton,
            profileNicknameButton,
            timeLabel,
            ellipsisButton,
            contentLabel
        ].forEach { contentView.addSubview($0) }
    }

    override func initialLayout() {
        super.initialLayout()

        let offset = 8
        let inset = 8
        profileImageButton.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(inset)
        }

        profileNicknameButton.snp.makeConstraints { make in
            make.top.equalTo(profileImageButton)
            make.leading.equalTo(profileImageButton.snp.trailing).offset(offset)
        }

        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(profileNicknameButton)
            make.trailing.equalTo(ellipsisButton.snp.leading).offset(-offset)
        }

        ellipsisButton.snp.makeConstraints { make in
            make.verticalEdges.equalTo(timeLabel)
            make.trailing.equalToSuperview().inset(inset)
        }

        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageButton.snp.bottom).offset(offset)
            make.horizontalEdges.equalToSuperview().inset(inset)
            make.bottom.equalToSuperview().inset(inset)
        }
    }

}
