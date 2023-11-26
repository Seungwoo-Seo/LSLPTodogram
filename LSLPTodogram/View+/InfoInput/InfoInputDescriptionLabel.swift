//
//  InfoInputDescriptionLabel.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/11/26.
//

import UIKit

final class InfoInputDescriptionLabel: BaseLabel {

    init(text: String?) {
        super.init(frame: .zero)
        self.text = text
    }

    override func initialAttributes() {
        super.initialAttributes()

        textColor = Color.black
        font = .systemFont(ofSize: 17, weight: .regular)
    }

}
