//
//  MiddlePointLabel.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/05.
//

import UIKit

final class MiddlePointLabel: BaseLabel {

    override func initialAttributes() {
        super.initialAttributes()

        text = "•"
        textColor = Color.black
        font = .systemFont(ofSize: 17, weight: .semibold)
        setContentHuggingPriority(.defaultHigh, for: .horizontal)
        setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    }

}


