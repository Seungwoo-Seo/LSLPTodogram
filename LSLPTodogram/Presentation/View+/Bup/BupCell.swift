//
//  BupCell.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/11.
//

import UIKit
import RxCocoa
import RxSwift
import Kingfisher

final class BupCell: BaseTableViewCell {
    var disposeBag = DisposeBag()

    let profileImageButton = ProfileImageButton()
    let profileNicknameButton = ProfileNicknameButton()
    let timeLabel = TimeLabel()
    let ellipsisButton = CommunicationButton(style: .ellipsis)
    let lineView = LineView()
    let contentLabel = ContentLabel()
    let imageCollectionView = ImageCollectionView(collectionViewLayout: .one(size: .zero))
    let commentUserImageView = UIView()
    let communicationButtonStackView = CommunicationButtonStackView()
    let countButtonStackView = CountButtonStackView()

    var likeCache: (row: Int, status: Bool, bup: Bup)?
    var baseImageUrls: [String]?
    let imageUrls = BehaviorRelay<[String]>(value: [])

    func bind(_ viewModel: BupCellViewModel) {
        // TODO: - updateImage
        profileImageButton.updateImage(image: UIImage(named: "profile"))
        profileNicknameButton.updateTitle(
            title: viewModel.bup.creator.nick
        )
        contentLabel.text = viewModel.bup.content
    }

    func configure(item: Bup, likeState: Bool?) {
        profileImageButton.updateImage(image: UIImage(named: "profile"))
        profileNicknameButton.updateTitle(title: item.creator.nick)
        contentLabel.text = item.content
        communicationButtonStackView.likeButton.isSelected = item.isIliked
        countButtonStackView.likeCountButton.updateTitle(title: item.serverLikesCountString())
        countButtonStackView.commentCountButton.updateTitle(title: item.commentCountString())

        // 좋아요 버튼의 상태 업데이트
        if let likeState = likeState {
            communicationButtonStackView.likeButton.isSelected = likeState
            countButtonStackView.likeCountButton.updateTitle(
                title: item.localLikesCountString(isSelected: likeState)
            )
        }


        baseImageUrls = item.image
        if let images = item.image {
            //           let _ = item.width,
            //           let height = item.height {
            let height = 200.0
            // 1개
            if images.count == 1 {
                imageCollectionView.snp.remakeConstraints { make in
                    make.top.equalTo(contentLabel.snp.bottom).offset(16/2)
                    make.horizontalEdges.equalTo(contentLabel)
                    make.height.equalTo(height/2)
                }

                layoutIfNeeded()

                // 1개 이상
            } else if images.count > 1  {
                imageCollectionView.snp.remakeConstraints { make in
                    make.top.equalTo(contentLabel.snp.bottom).offset(16/2)
                    make.horizontalEdges.equalToSuperview()
                    make.height.equalTo(height)
                }

                layoutIfNeeded()

            } else {
                // 0개
                imageCollectionView.snp.remakeConstraints { make in
                    make.top.equalTo(contentLabel.snp.bottom)
                    make.horizontalEdges.equalToSuperview()
                    make.height.equalTo(0)
                }

                layoutIfNeeded()

                imageUrls.accept([])
            }

            imageUrls.accept(images)
        }
    }

    func configure(item: Bup) {
        profileImageButton.updateImage(image: UIImage(named: "profile"))
        profileNicknameButton.updateTitle(title: item.creator.nick)
        contentLabel.text = item.content

//        communication
        if let likeCache = likeCache {
            // 있으면 캐시를 따라가고
            if let likes = likeCache.bup.likes {

                if likeCache.status {
                    countButtonStackView.likeCountButton.configuration?.title = "\(likes.count + 1) 좋아요"
                    communicationButtonStackView.likeButton.isSelected = true
                } else {
                    countButtonStackView.likeCountButton.configuration?.title = "\(likes.count - 1) 좋아요"
                    communicationButtonStackView.likeButton.isSelected = false
                }
            } else {
                countButtonStackView.likeCountButton.configuration?.title = "0 좋아요"
            }

        } else {
            // 없으면 기본을 간다.
            if let likes = item.likes {
                // likes가 있으면 카운팅을 해주고
                countButtonStackView.likeCountButton.configuration?.title = "\(likes.count) 좋아요"

                if likes.contains(item.creator.id) {
                    communicationButtonStackView.likeButton.isSelected = true
                } else {
                    communicationButtonStackView.likeButton.isSelected = false
                }

            } else {
                countButtonStackView.likeCountButton.configuration?.title = "0 좋아요"
            }
        }



        if let comments = item.comments {
            countButtonStackView.commentCountButton.configuration?.title = "\(comments.count) 답글"
        } else {
            countButtonStackView.commentCountButton.configuration?.title = "0 답글"
        }


        baseImageUrls = item.image
        if let images = item.image {
            //           let _ = item.width,
            //           let height = item.height {
            let height = 200.0
            // 1개
            if images.count == 1 {
                imageCollectionView.snp.remakeConstraints { make in
                    make.top.equalTo(contentLabel.snp.bottom).offset(16/2)
                    make.horizontalEdges.equalTo(contentLabel)
                    make.height.equalTo(height/2)
                }

                layoutIfNeeded()

                // 1개 이상
            } else if images.count > 1  {
                imageCollectionView.snp.remakeConstraints { make in
                    make.top.equalTo(contentLabel.snp.bottom).offset(16/2)
                    make.horizontalEdges.equalToSuperview()
                    make.height.equalTo(height)
                }

                layoutIfNeeded()
                
            } else {
                // 0개
                imageCollectionView.snp.remakeConstraints { make in
                    make.top.equalTo(contentLabel.snp.bottom)
                    make.horizontalEdges.equalToSuperview()
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

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        if let urls = baseImageUrls {
            let height = 200.0
            if urls.count == 1 {
                imageCollectionView.collectionViewLayout = ImageCollectionViewLayout.one(
                    size: CGSize(width: imageCollectionView.bounds.width, height: height/2)
                ).layout
            } else if urls.count > 1 {
                imageCollectionView.collectionViewLayout = ImageCollectionViewLayout.many(
                    size: CGSize(width: imageCollectionView.bounds.width / 2, height: height)
                ).layout
            } else {

            }
        }
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
            lineView,
            contentLabel,
            imageCollectionView,
            communicationButtonStackView,
            countButtonStackView
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
            make.leading.equalTo(profileNicknameButton.snp.trailing).offset(offset)
        }

        ellipsisButton.snp.makeConstraints { make in
            make.verticalEdges.equalTo(timeLabel)
            make.leading.equalTo(timeLabel.snp.trailing).offset(offset)
            make.trailing.equalToSuperview().inset(inset)
        }

        lineView.snp.makeConstraints { make in
            make.top.equalTo(profileImageButton.snp.bottom).offset(offset)
            make.centerX.equalTo(profileImageButton)
            make.bottom.equalTo(communicationButtonStackView)
        }

        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(profileNicknameButton.snp.bottom).offset(offset)
            make.leading.equalTo(profileNicknameButton.snp.leading)
            make.trailing.equalTo(ellipsisButton.snp.trailing)
        }

        imageCollectionView.setContentCompressionResistancePriority(.init(1), for: .vertical)
        imageCollectionView.setContentHuggingPriority(.init(1), for: .vertical)
        imageCollectionView.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(0)
        }

        communicationButtonStackView.snp.makeConstraints { make in
            make.top.equalTo(imageCollectionView.snp.bottom).offset(offset)
            make.leading.equalTo(contentLabel.snp.leading)
            make.trailing.lessThanOrEqualTo(contentLabel.snp.trailing)
        }

        countButtonStackView.snp.makeConstraints { make in
            make.top.equalTo(communicationButtonStackView.snp.bottom).offset(offset)
            make.leading.equalTo(contentLabel.snp.leading)
            make.trailing.lessThanOrEqualTo(contentLabel.snp.trailing)
            make.bottom.equalToSuperview().inset(inset)
        }
    }

}
