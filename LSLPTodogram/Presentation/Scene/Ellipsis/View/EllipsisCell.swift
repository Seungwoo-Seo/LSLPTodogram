//
//  EllipsisCell.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2024/01/09.
//

import UIKit
import RxCocoa
import RxSwift

final class EllipsisCell: BaseTableViewCell {
    var disposeBag = DisposeBag()

    let titleLabel = {
        let label = UILabel()
        label.textColor = Color.black
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        return label
    }()

    func configure(_ item: String) {
        if item == "삭제하기" {
            let attributedText = NSAttributedString(string: item, attributes: [.foregroundColor: Color.red])
            titleLabel.attributedText = attributedText
        } else {
            titleLabel.text = item
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        disposeBag = DisposeBag()
    }

    override func initialAttributes() {
        super.initialAttributes()

        contentView.backgroundColor = Color.lightGray.withAlphaComponent(0.12)
    }

    override func initialHierarchy() {
        super.initialHierarchy()

        contentView.addSubview(titleLabel)
    }

    override func initialLayout() {
        super.initialLayout()

        let inset = 8
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(inset)
        }
    }
}
