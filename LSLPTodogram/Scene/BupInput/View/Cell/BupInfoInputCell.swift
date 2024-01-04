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
    private let profileImageView = ProfileImageView(image: UIImage(systemName: "person.fill"))
    private let labelStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .top
        view.distribution = .equalSpacing
        view.spacing = 4
        return view
    }()
    private let nicknameLabel = NicknameLabel()
    private let phoneNumLabel = NicknameLabel()
    let titleTextView = {
        let view = UITextView()
        view.text = "과제, 목표, 각오 등 제목을 작성.."
        view.textColor = Color.black
        view.font = .systemFont(ofSize: 16, weight: .semibold)
        view.isScrollEnabled = false
        view.sizeToFit()
        return view
    }()

    var disposeBag = DisposeBag()

    func configure(_ item: BupInfoInput) {
        profileImageView.image = UIImage(systemName: "person")
        nicknameLabel.text = item.nickname
        titleTextView.text = item.title
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        disposeBag = DisposeBag()
    }

    override func initialAttributes() {
        super.initialAttributes()

        selectionStyle = .none
    }

    override func initialHierarchy() {
        super.initialHierarchy()

        contentView.addSubview(hStackView)

        [
            hStackView,
            titleTextView
        ].forEach { addSubview($0) }

        [
            profileImageView,
            labelStackView
        ].forEach { hStackView.addArrangedSubview($0) }

        [
            nicknameLabel,
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

        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(40)
        }

        titleTextView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(offset)
            make.horizontalEdges.bottom.equalToSuperview().inset(inset)
        }
    }

}
