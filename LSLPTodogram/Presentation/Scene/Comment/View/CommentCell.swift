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

    let profileImageButton = ProfileImageButton()
    let profileNicknameButton = ProfileNicknameButton()
    let lineView = LineView()
    let commentTextView = {
        let view = UITextView()
        view.text = "답글 남기기..."
        view.textColor = Color.lightGray
        view.font = .systemFont(ofSize: 15, weight: .semibold)
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
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
            profileImageButton,
            profileNicknameButton,
            lineView,
            commentTextView
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

        commentTextView.snp.makeConstraints { make in
            make.top.equalTo(profileNicknameButton.snp.bottom).offset(offset)
            make.leading.equalTo(profileNicknameButton.snp.leading)
            make.trailing.equalToSuperview().inset(inset)
            make.bottom.equalToSuperview().inset(inset)
        }

        lineView.snp.makeConstraints { make in
            make.top.equalTo(profileImageButton.snp.bottom).offset(offset)
            make.centerX.equalTo(profileImageButton)
            make.bottom.equalTo(commentTextView.snp.bottom)
        }
    }
}


