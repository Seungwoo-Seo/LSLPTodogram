//
//  BupContentView.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/12.
//

import UIKit

final class BupContentView: BaseView {
    
    let bupContentLabel = BupContentLabel()

    func reset() {
        bupContentLabel.text = nil
    }

    override func initialAttributes() {
        super.initialAttributes()

        isHidden = true
        bupContentLabel.text = "시발 좀 되라"
    }

    override func initialHierarchy() {
        super.initialHierarchy()

        addSubview(bupContentLabel)
    }

    override func initialLayout() {
        super.initialLayout()

        let inset = 4
        bupContentLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(inset)
            make.horizontalEdges.equalToSuperview().inset(inset * 4)
        }
    }

}
