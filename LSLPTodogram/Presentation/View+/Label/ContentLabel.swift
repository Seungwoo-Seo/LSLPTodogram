//
//  ContentLabel.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/24.
//

import UIKit

final class ContentLabel: BaseLabel {

    override func initialAttributes() {
        super.initialAttributes()

        textColor = Color.black
        font = .systemFont(ofSize: 15, weight: .regular)
        numberOfLines = 0
    }

}
