//
//  ErrorLabel.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/11/26.
//

import UIKit

final class ErrorLabel: BaseLabel {

    override func initialAttributes() {
        super.initialAttributes()

        numberOfLines = 0
        font = .systemFont(ofSize: 15, weight: .regular)
        isHidden = true
    }

}
