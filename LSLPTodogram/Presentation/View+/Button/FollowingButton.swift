//
//  FollowingButton.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/14.
//

import UIKit

final class FollowingButton: BaseButton {

    init() {
        super.init(frame: .zero)

        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = Color.white.withAlphaComponent(0.7)
        config.background.backgroundColor = Color.clear
        config.contentInsets = NSDirectionalEdgeInsets(
            top: 0, leading: 0, bottom: 0, trailing: 0
        )
        config.title = "팔로잉 0명"
        configuration = config
    }

    func updateTitle(_ title: String?) {
        configuration?.title = title
    }
    
}
