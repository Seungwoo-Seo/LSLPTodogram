//
//  BupTitleLabel.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/05.
//

import UIKit

final class BupTitleLabel: BaseLabel {

    override func initialAttributes() {
        super.initialAttributes()

        numberOfLines = 0
        textColor = Color.black
        font = .systemFont(ofSize: 17, weight: .semibold)
    }

}
