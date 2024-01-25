//
//  CommentOwnerCell.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/29.
//

import UIKit
import RxCocoa
import RxSwift
import Kingfisher

final class CommentOwnerCell: BaseTableViewCell {
    var disposeBag = DisposeBag()

    let profileImageButton = ProfileImageButton()
    let profileNicknameButton = ProfileNicknameButton()
    let timeLabel = TimeLabel()
    let lineView = LineView()
    let contentLabel = ContentLabel()
    let imageCollectionView = ImageCollectionView(collectionViewLayout: .one(size: .zero))

    let imageUrls = BehaviorRelay<[String]>(value: [])


    func configure(item: Bup) {
        profileImageButton.updateImage(image: UIImage(named: "profile"))
        profileNicknameButton.updateTitle(title: item.creator.nick)
        if let content = item.content {
            contentLabel.setHashTags(text: content)
        }

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

        if let images = item.image {
//           let _ = item.width,
//           let height = item.height {
            let height = 200.0
            // 1개
            if images.count == 1 {
                imageCollectionView.snp.remakeConstraints { make in
                    make.top.equalTo(contentLabel.snp.bottom).offset(16/2)
                    make.horizontalEdges.equalTo(contentLabel)
                    make.bottom.equalToSuperview()
                    make.height.equalTo(height/2)
                }

                layoutIfNeeded()

                imageCollectionView.collectionViewLayout = ImageCollectionViewLayout.one(
                    size: CGSize(width: contentLabel.bounds.width, height: height/2)
                ).layout

                // 1개 이상
            } else if images.count > 1  {
                imageCollectionView.snp.remakeConstraints { make in
                    make.top.equalTo(contentLabel.snp.bottom).offset(16/2)
                    make.horizontalEdges.equalToSuperview()
                    make.bottom.equalToSuperview()
                    make.height.equalTo(height)
                }

                layoutIfNeeded()

                imageCollectionView.collectionViewLayout = ImageCollectionViewLayout.many(
                    size: CGSize(width: imageCollectionView.bounds.width / 2, height: height)
                ).layout
            } else {
                // 0개
                imageCollectionView.snp.remakeConstraints { make in
                    make.top.equalTo(contentLabel.snp.bottom)
                    make.horizontalEdges.equalToSuperview()
                    make.bottom.equalToSuperview()
                    make.height.equalTo(0)
                }

                layoutIfNeeded()

                imageUrls.accept([])
            }

            imageUrls.accept(images)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        disposeBag = DisposeBag()
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
            lineView,
            contentLabel,
            imageCollectionView
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
            make.trailing.lessThanOrEqualToSuperview().inset(inset)
        }

        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageButton)
            make.trailing.equalToSuperview().offset(-offset)
        }

        lineView.snp.makeConstraints { make in
            make.top.equalTo(profileImageButton.snp.bottom).offset(offset)
            make.centerX.equalTo(profileImageButton)
            make.bottom.equalTo(imageCollectionView.snp.bottom)
        }

        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(profileNicknameButton.snp.bottom).offset(offset)
            make.leading.equalTo(profileNicknameButton.snp.leading)
            make.trailing.equalToSuperview().inset(inset)
        }

        imageCollectionView.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(0)
        }
    }

}

