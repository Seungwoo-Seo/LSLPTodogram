//
//  ProfileEditMainView.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/15.
//

import UIKit
import RxCocoa
import RxSwift

final class ProfileEditMainView: BaseView {
    let backgroundImageView = {
        let view = UIImageView(image: UIImage(named: "fireBackground"))
        view.alpha = 0.7
        return view
    }()
    let profileImageButton = ProfileImageButton(size: CGSize(width: 100, height: 100))
    let nicknameView = InfoInputView(description: "닉네임", placeholder: "")
    let phoneNumView = InfoInputView(description: "핸드폰 번호", placeholder: "")
    let datePicker = {
        let view = UIDatePicker()
        view.maximumDate = Date()
        view.datePickerMode = .date
        view.preferredDatePickerStyle = .wheels
        view.locale = Locale(identifier: "ko-KR")
        return view
    }()
    lazy var birthDayView = {
        let view = InfoInputView(description: "생년월일", placeholder: "")
        view.textField.inputView = datePicker
        return view
    }()

    override func initialAttributes() {
        super.initialAttributes()

        nicknameView.backgroundColor = Color.clear
        phoneNumView.backgroundColor = Color.clear
        birthDayView.backgroundColor = Color.clear
    }

    override func initialHierarchy() {
        super.initialHierarchy()

        addSubview(backgroundImageView)
        [
            profileImageButton,
            nicknameView,
            phoneNumView,
            birthDayView
        ].forEach { addSubview($0) }
    }

    override func initialLayout() {
        super.initialLayout()

        let offset = 16
        let inset = 16
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        profileImageButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(offset*2)
            make.centerX.equalToSuperview()
        }

        nicknameView.snp.makeConstraints { make in
            make.top.equalTo(profileImageButton.snp.bottom).offset(offset*2)
            make.horizontalEdges.equalToSuperview().inset(inset)
        }

        phoneNumView.snp.makeConstraints { make in
            make.top.equalTo(nicknameView.snp.bottom).offset(offset)
            make.horizontalEdges.equalToSuperview().inset(inset)
        }

        birthDayView.snp.makeConstraints { make in
            make.top.equalTo(phoneNumView.snp.bottom).offset(offset)
            make.horizontalEdges.equalToSuperview().inset(inset)
        }
    }
}
