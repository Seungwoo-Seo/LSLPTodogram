//
//  BupCell.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/11.
//

import UIKit
import RxCocoa
import RxSwift

final class BupCell: BaseTableViewCell {
    var disposeBag = DisposeBag()

    let bupView = BupView()

    func configure(_ item: Bup) {
        bupView.infoView.profileImageView.image = UIImage(systemName: "person")
        bupView.infoView.nicknameLabel.text = item.creator.nick
        bupView.infoView.titleLabel.text = item.title

        bupView.contentView0.bupContentLabel.text = item.content0
        bupView.contentView1.bupContentLabel.text = item.content1
        bupView.contentView2.bupContentLabel.text = item.content2

        let contentStackView = bupView.contentStackView
        for subview in contentStackView.arrangedSubviews {
            if let contentView = subview as? BupContentView {
                if !(contentView.bupContentLabel.text!.isEmpty) {
                    contentView.isHidden = false
                } else {
                    contentView.isHidden = true
                }
            }
        }

        if let likes = item.likes {
            print("✅ likes --> ", likes)
            print("✅ item.creator.id --> ", item.creator.id)
            if likes.contains(item.creator.id) {
                bupView.communicationView.likeButton.isSelected = true
            } else {
                bupView.communicationView.likeButton.isSelected = false
            }
            bupView.communicationView.likeCountButton.configuration?.title = "\(likes.count) 좋아요"
        } else {
            bupView.communicationView.likeCountButton.configuration?.title = "0 좋아요"
        }

        if let comments = item.comments {
            bupView.communicationView.commentCountButton.configuration?.title = "\(comments.count) 답글"
        } else {
            bupView.communicationView.commentCountButton.configuration?.title = "0 답글"
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        disposeBag = DisposeBag()
    }

    override func initialHierarchy() {
        super.initialHierarchy()

        contentView.addSubview(bupView)
    }

    override func initialLayout() {
        super.initialLayout()

        bupView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
    }

}
