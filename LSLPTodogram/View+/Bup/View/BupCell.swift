//
//  BupCell.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/11/30.
//

import UIKit

final class BupCell: BaseCollectionViewCell {
    private let middlePointLabel = MiddlePointLabel()
    let bupContentLabel = BupContentLabel()

    func configure(_ item: BupContent) {
        bupContentLabel.text = item.content
    }

    override func initialAttributes() {
        super.initialAttributes()

        contentView.backgroundColor = Color.green
    }

    override func initialHierarchy() {
        super.initialHierarchy()

        [
            middlePointLabel,
            bupContentLabel
        ].forEach { contentView.addSubview($0) }
    }

    override func initialLayout() {
        super.initialLayout()

        let offset = 16
        let inset = 8
        middlePointLabel.snp.makeConstraints { make in
            make.centerY.equalTo(bupContentLabel)
            make.leading.equalToSuperview().offset(offset)
            make.height.equalTo(bupContentLabel)
        }
        bupContentLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(inset)
            make.leading.equalTo(middlePointLabel.snp.trailing).offset(offset)
            make.trailing.equalToSuperview().offset(-offset)
        }
    }

}
