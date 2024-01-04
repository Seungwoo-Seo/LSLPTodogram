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

        textColor = Color.lightGray
        font = .systemFont(ofSize: 15, weight: .semibold)
    }

}
