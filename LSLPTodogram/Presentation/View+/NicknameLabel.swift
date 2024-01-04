//
//  NicknameLabel.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/05.
//

import UIKit

final class NicknameLabel: BaseLabel {

    init(fontSize: CGFloat = 15, weight: UIFont.Weight = .semibold) {
        super.init(frame: .zero)

        numberOfLines = 0
        textColor = Color.black
        font = .systemFont(ofSize: fontSize, weight: weight)
    }

}
