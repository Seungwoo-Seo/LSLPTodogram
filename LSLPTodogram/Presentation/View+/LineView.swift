//
//  LineView.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/24.
//

import UIKit

final class LineView: BaseView {

    override func initialAttributes() {
        super.initialAttributes()

        backgroundColor = Color.white
    }

    override func initialLayout() {
        super.initialLayout()

        snp.makeConstraints { make in
            make.width.equalTo(1)
        }
    }
}
