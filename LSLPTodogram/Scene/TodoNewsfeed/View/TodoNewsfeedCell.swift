//
//  TodoNewsfeedCell.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/11/30.
//

import UIKit

final class TodoNewsfeedCell: BaseCollectionViewCell {
    private let middlePointLabel = {
        let label = UILabel()
        label.text = "•"
        label.textColor = Color.black
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return label
    }()
    let todoLabel = {
        let label = UILabel()
        label.textColor = Color.black
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()

    override func initialHierarchy() {
        super.initialHierarchy()

        [middlePointLabel, todoLabel].forEach { contentView.addSubview($0) }
    }

    override func initialLayout() {
        super.initialLayout()

        let offset = 16
        let inset = 8
        middlePointLabel.snp.makeConstraints { make in
            make.top.equalTo(todoLabel.snp.top)
            make.leading.equalToSuperview().offset(offset)
        }
        todoLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(inset)
            make.leading.equalTo(middlePointLabel.snp.trailing).offset(offset/4)
            make.trailing.equalToSuperview().inset(inset*2)
        }
    }

}
