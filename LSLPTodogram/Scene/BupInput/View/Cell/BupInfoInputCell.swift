//
//  BupInfoInputCell.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/01.
//

import UIKit
import RxSwift
import Kingfisher

final class BupInfoInputCell: BaseTableViewCell {
    private let hStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .top
        view.distribution = .fill
        view.spacing = 16
        return view
    }()
    private let profileImageButton = ProfileImageButton()
    private let labelStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .top
        view.distribution = .equalSpacing
        view.spacing = 4
        return view
    }()
    private let profileNicknameButton = ProfileNicknameButton()
    private let phoneNumLabel = NicknameLabel()
    let titleTextView = {
        let view = UITextView()
        view.text = "과제, 목표, 각오 등 제목을 작성.."
        view.textColor = Color.black
        view.font = .systemFont(ofSize: 16, weight: .semibold)
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.isScrollEnabled = false
        view.sizeToFit()
        return view
    }()

    var disposeBag = DisposeBag()

    func configure(_ item: BupInfoInput) {
        profileImageButton.configuration?.image = UIImage(named: "profile")
        profileNicknameButton.configuration?.title = item.nickname
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        disposeBag = DisposeBag()
    }

    override func initialHierarchy() {
        super.initialHierarchy()

        [
            hStackView,
            titleTextView
        ].forEach { contentView.addSubview($0) }

        [
            profileImageButton,
            labelStackView
        ].forEach { hStackView.addArrangedSubview($0) }

        [
            profileNicknameButton,
            phoneNumLabel
        ].forEach { labelStackView.addArrangedSubview($0) }
    }

    override func initialLayout() {
        super.initialLayout()

        let offset = 16
        let inset = 16
        hStackView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(inset)
        }

        profileImageButton.snp.makeConstraints { make in
            make.size.equalTo(40)
        }

        titleTextView.snp.makeConstraints { make in
            make.top.equalTo(profileImageButton.snp.bottom).offset(offset)
            make.horizontalEdges.bottom.equalToSuperview().inset(inset)
        }
    }

}
