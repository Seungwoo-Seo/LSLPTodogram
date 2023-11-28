//
//  InfoInputTextField.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/11/26.
//

import UIKit

final class InfoInputTextField: BaseTextField {

    init(placeholder: String?) {
        super.init(frame: .zero)
        self.placeholder = placeholder
    }

    override func initialAttributes() {
        super.initialAttributes()

        tintColor = Color.red
        textColor = Color.black
        clearButtonMode = .always
        borderStyle = .roundedRect
        setContentHuggingPriority(.defaultLow, for: .horizontal)
        setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }

}
