//
//  ProfileNicknameButton.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/24.
//

import UIKit

final class ProfileNicknameButton: BaseButton {

    private let size: CGFloat

    init(size: CGFloat = 16) {
        self.size = size
        super.init(frame: .zero)

        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = Color.black
        config.background.backgroundColor = Color.clear
        config.contentInsets = NSDirectionalEdgeInsets(
            top: 0, leading: 0, bottom: 0, trailing: 0
        )
        config.attributedTitle = AttributedString(
            "unknown",
            attributes: AttributeContainer([.font: UIFont.systemFont(ofSize: size, weight: .semibold)])
        )
        configuration = config
    }

    func updateTitle(title: String) {
        configuration?.attributedTitle = AttributedString(
            title,
            attributes: AttributeContainer([.font: UIFont.systemFont(ofSize: size, weight: .semibold)])
        )
    }

}
