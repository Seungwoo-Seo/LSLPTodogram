//
//  ProfileImageView.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/05.
//

import UIKit

final class ProfileImageView: BaseImageView {

    override init(image: UIImage?) {
        super.init(image: image)

        setContentHuggingPriority(.defaultHigh, for: .vertical)
        setContentHuggingPriority(.defaultHigh, for: .horizontal)
        setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        contentMode = .scaleAspectFit
        layer.borderColor = Color.black.cgColor
        layer.borderWidth = 0.5
        clipsToBounds = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = bounds.height/2
    }
}
