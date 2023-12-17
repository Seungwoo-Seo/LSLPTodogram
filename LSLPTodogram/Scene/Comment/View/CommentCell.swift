//
//  CommentCell.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/14.
//

import UIKit
import RxCocoa
import RxSwift

final class CommentCell: BaseTableViewCell {
    var disposeBag = DisposeBag()

    let profileImageView = ProfileImageView(image: UIImage(systemName: "person"))
    let nicknameLabel = NicknameLabel()
    let commentTextView = {
        let view = UITextView()
        view.textColor = Color.lightGray
        view.text = "답글 남기기..."
        view.font = .systemFont(ofSize: 15, weight: .semibold)
        view.isScrollEnabled = false
        view.sizeToFit()
        return view
    }()

    override func prepareForReuse() {
        super.prepareForReuse()

        disposeBag = DisposeBag()
    }

    override func initialHierarchy() {
        super.initialHierarchy()

        [
            profileImageView,
            nicknameLabel,
            commentTextView
        ].forEach { contentView.addSubview($0) }
    }

    override func initialLayout() {
        super.initialLayout()

        let offset = 16
        let inset = 16
        profileImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(inset)
            make.size.equalTo(40)
        }

        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView)
            make.leading.equalTo(profileImageView.snp.trailing).offset(offset)
            make.trailing.equalToSuperview().inset(inset)
        }

        commentTextView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(offset)
            make.horizontalEdges.equalToSuperview().inset(inset)
            make.bottom.equalToSuperview().inset(inset)
        }
    }
}


