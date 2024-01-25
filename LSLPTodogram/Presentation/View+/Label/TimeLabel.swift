//
//  TimeLabel.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/24.
//

import UIKit

final class TimeLabel: BaseLabel {

    override func initialAttributes() {
        super.initialAttributes()

        textColor = Color.white.withAlphaComponent(0.5)
        font = .systemFont(ofSize: 15, weight: .semibold)
    }

}
