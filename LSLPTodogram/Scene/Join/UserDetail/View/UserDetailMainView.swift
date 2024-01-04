//
//  UserDetailMainView.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/11/23.
//

import UIKit

final class UserDetailMainView: BaseView {
    private let titleLabel = InfoInputTitleLabel(text: "추가 정보 입력")
    let nicknameView = InfoInputView(description: "닉네임을 정해주세요. (필수)", placeholder: "2글자 이상 입력해주세요.")
    let phoneNumView = InfoInputView(description: "핸드폰 번호를 입력해주세요. (선택)", placeholder: "- 를 빼고 입력해주세요.")
    let datePicker = {
        let view = UIDatePicker()
        view.maximumDate = Date()
        view.datePickerMode = .date
        view.preferredDatePickerStyle = .wheels
        view.locale = Locale(identifier: "ko-KR")
        return view
    }()
    lazy var birthDayView = {
        let view = InfoInputView(description: "생년월일을 입력해주세요. (선택)", placeholder: "yyyy년 MM월 dd일")
        view.textField.inputView = datePicker
        return view
    }()
    let joinButton = InfoInputButton(title: "가입하기")
    let prevButton = InfoInputButton(title: "이전")

    override func initialHierarchy() {
        super.initialHierarchy()

        [
            titleLabel,
            nicknameView,
            phoneNumView,
            birthDayView,
            joinButton,
            prevButton
        ].forEach { addSubview($0) }
    }

    override func initialLayout() {
        super.initialLayout()

        let offset = 16
        let inset = 16
        let height = 44
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(inset)
            make.horizontalEdges.equalToSuperview().inset(inset)
        }

        nicknameView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(offset*2)
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

        joinButton.snp.makeConstraints { make in
            make.top.equalTo(birthDayView.snp.bottom).offset(offset*2)
            make.horizontalEdges.equalToSuperview().inset(inset)
            make.height.equalTo(height)
        }

        prevButton.snp.makeConstraints { make in
            make.top.equalTo(joinButton.snp.bottom).offset(offset)
            make.horizontalEdges.equalToSuperview().inset(inset)
            make.height.equalTo(height)
        }
    }

}
