//
//  EmptyCell.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2024/01/08.
//

import UIKit

final class EmptyCell: BaseTableViewCell {
    let label = {
        let label = UILabel()
        label.textColor = Color.white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15, weight: .regular)
        return label
    }()

    func configure(placeholder: String) {
        label.text = placeholder
    }

    override func initialHierarchy() {
        super.initialHierarchy()

        contentView.addSubview(label)
    }

    override func initialLayout() {
        super.initialLayout()

        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(44)
        }
    }

}
