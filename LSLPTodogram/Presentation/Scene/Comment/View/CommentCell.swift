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

    func configure(_ item: Profile) {
        if let imageString = item.profileImageString {
            profileImageButton.imageView?.requestModifier(with: imageString) { [weak self] (image) in
                guard let self else {return}
                self.profileImageButton.updateImage(image: image)
            }
        } else {
            profileImageButton.updateImage(image: UIImage(named: "profile"))
        }
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

enum TimeDifference {
    case seconds(Int)
    case minutes(Int)
    case hours(Int)
    case days(Int)
}

func calculateTimeDifference(from dateString: String) -> TimeDifference? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    
    guard let date = dateFormatter.date(from: dateString) else {
        return nil // 날짜 형식이 맞지 않는 경우 nil 반환
    }

    let currentDate = Date()
    let calendar = Calendar.current
    let components = calendar.dateComponents([.second, .minute, .hour, .day], from: date, to: currentDate)

    if let days = components.day, days > 0 {
        return .days(days)
    } else if let hours = components.hour, hours > 0 {
        return .hours(hours)
    } else if let minutes = components.minute, minutes > 0 {
        return .minutes(minutes)
    } else if let seconds = components.second {
        return .seconds(seconds)
    } else {
        return .seconds(0) // 기타 예외 상황에 대한 처리
    }
}


