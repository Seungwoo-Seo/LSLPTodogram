//
//  ProfileImageView.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/05.
//

import UIKit

final class ProfileImageView: BaseImageView {
    
    override func initialAttributes() {
        super.initialAttributes()

        setContentHuggingPriority(.defaultHigh, for: .vertical)
        setContentHuggingPriority(.defaultHigh, for: .horizontal)
        setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        contentMode = .scaleAspectFit
        layer.borderColor = Color.black.cgColor
        layer.borderWidth = 0.5
        layer.cornerRadius = 20
        clipsToBounds = true
    }

    override func initialLayout() {
        super.initialLayout()

        snp.makeConstraints { make in
            make.size.equalTo(40)
        }
    }

}
