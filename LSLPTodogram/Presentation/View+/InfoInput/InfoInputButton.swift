//
//  InfoInputButton.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/11/26.
//

import UIKit

final class InfoInputButton: BaseButton {

    init(
        title: String?,
        cornerStyle: UIButton.Configuration.CornerStyle = .capsule
    ) {
        super.init(frame: .zero)
        configuration?.title = title
        configuration?.cornerStyle = cornerStyle
    }

    override func initialAttributes() {
        super.initialAttributes()

        var config = UIButton.Configuration.filled()
        config.background.backgroundColor = Color.red
        config.cornerStyle = .capsule
        configuration = config
        configurationUpdateHandler = { button in
            switch button.state {
            case .disabled:
                button.configuration?.background.backgroundColor = Color.red.withAlphaComponent(0.12)
            default:
                button.configuration?.background.backgroundColor = Color.red
            }
        }


        setContentHuggingPriority(.defaultHigh, for: .horizontal)
        setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    }

}
