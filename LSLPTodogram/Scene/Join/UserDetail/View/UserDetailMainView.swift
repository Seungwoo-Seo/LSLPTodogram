//
//  UserDetailMainView.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/11/23.
//

import UIKit

final class UserDetailMainView: BaseView {
    let titleLabel = {
        let view = UILabel()
        view.textColor = Color.black
        view.font = .systemFont(ofSize: 24, weight: .bold)
        view.text = "추가 정보 입력"
        return view
    }()
    let nicknameView = InfoInputView(description: "닉네임을 정해주세요. (필수)")
    let phoneNumView = InfoInputView(description: "핸드폰 번호를 입력해주세요. (선택)")
    let birthDayView = InfoInputView(description: "생년월일을 입력해주세요. (선택)")

    let completeButton = {
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .capsule
        config.title = "가입하기"
        let button = UIButton(configuration: config)
        return button
    }()

    override func initialHierarchy() {
        super.initialHierarchy()

        [
            titleLabel,
            nicknameView,
            phoneNumView,
            birthDayView,
            completeButton
        ].forEach { addSubview($0) }
    }

    override func initialLayout() {
        super.initialLayout()

        let offset = 16
        let inset = 16
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

        completeButton.snp.makeConstraints { make in
            make.top.equalTo(birthDayView.snp.bottom).offset(offset*2)
            make.horizontalEdges.equalToSuperview().inset(inset)
            make.height.equalTo(44)
        }
    }

}
