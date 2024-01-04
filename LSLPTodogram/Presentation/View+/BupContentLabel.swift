//
//  BupContentLabel.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/05.
//

import UIKit

final class BupContentLabel: BaseLabel {

    override func initialAttributes() {
        super.initialAttributes()

        textColor = Color.black
        numberOfLines = 0
        font = .systemFont(ofSize: 17, weight: .semibold)
        setContentHuggingPriority(.defaultLow, for: .horizontal)
        setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }

}

