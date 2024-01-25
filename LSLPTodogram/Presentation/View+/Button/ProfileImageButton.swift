//
//  ProfileImageButton.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/24.
//

import UIKit

final class ProfileImageButton: BaseButton {

    private let size: CGSize

    init(size: CGSize = CGSize(width: 36, height: 36)) {
        self.size = size
        super.init(frame: .zero)

        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = Color.clear
        config.background.backgroundColor = Color.clear
        config.contentInsets = NSDirectionalEdgeInsets(
            top: 0, leading: 0, bottom: 0, trailing: 0
        )
        config.image = UIImage(named: "profile")?.resize(targetSize: size)
        config.cornerStyle = .capsule
        configuration = config
    }

    func updateImage(image: UIImage?) {
        configuration?.image = image?.resize(targetSize: size)
        imageView?.clipsToBounds = true
        imageView?.layer.cornerRadius = size.height/2
    }

    override func initialAttributes() {
        super.initialAttributes()

        setContentHuggingPriority(.required, for: .horizontal)
        setContentHuggingPriority(.required, for: .vertical)
        setContentCompressionResistancePriority(.required, for: .horizontal)
        setContentCompressionResistancePriority(.required, for: .vertical)
    }

}
