//
//  InputCommunicationButtonStackView.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/24.
//

import UIKit

final class InputCommunicationButtonStackView: BaseStackView {
    let imageButton = CommunicationButton(style: .image)
    let hashTagButton = CommunicationButton(style: .hashTag)

    override func initialAttributes() {
        super.initialAttributes()

        axis = .horizontal
        alignment = .fill
        distribution = .fillEqually
        spacing = 16
    }

    override func initialHierarchy() {
        super.initialHierarchy()

        [
            imageButton,
            hashTagButton
        ].forEach { addArrangedSubview($0) }
    }
}

