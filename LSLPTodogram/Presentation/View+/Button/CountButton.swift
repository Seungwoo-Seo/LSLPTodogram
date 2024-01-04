//
//  CountButton.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/24.
//

import UIKit

final class CountButton: BaseButton {

    private let fontSize: CGFloat

    init(fontSize: CGFloat = 15) {
        self.fontSize = fontSize
        super.init(frame: .zero)

        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = Color.white.withAlphaComponent(0.7)
        config.background.backgroundColor = Color.clear
        config.contentInsets = NSDirectionalEdgeInsets(
            top: 0, leading: 0, bottom: 0, trailing: 0
        )
        configuration = config
    }

    func updateTitle(title: String) {
        configuration?.attributedTitle = AttributedString(
            title,
            attributes: AttributeContainer([.font: UIFont.systemFont(ofSize: fontSize, weight: .medium)])
        )
    }

}
