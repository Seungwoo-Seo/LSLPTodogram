//
//  TodoInfoInputCell.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/01.
//

import UIKit
import RxSwift

final class TodoInfoInputCell: BaseTableViewCell {
    private let hStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .top
        view.distribution = .fill
        view.spacing = 16
        return view
    }()
    let profileImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    private let vStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .equalSpacing
        view.spacing = 4
        return view
    }()
    let nicknameLabel = {
        let label = UILabel()
        label.textColor = Color.black
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        return label
    }()
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

    override func prepareForReuse() {
        super.prepareForReuse()

        disposeBag = DisposeBag()
    }

    override func initialHierarchy() {
        super.initialHierarchy()

        contentView.addSubview(hStackView)

        [
            profileImageView,
            vStackView
        ].forEach { hStackView.addArrangedSubview($0) }

        [
            nicknameLabel,
            titleTextView
        ].forEach { vStackView.addArrangedSubview($0) }
    }

    override func initialLayout() {
        super.initialLayout()

        let inset = 16
        hStackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(inset)
            make.bottom.equalToSuperview().inset(inset/2)
        }

        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(44)
        }
    }

}
