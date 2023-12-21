//
//  BupInfoView.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/12.
//

import UIKit

extension UIImage {
    func resize(targetSize: CGSize) -> UIImage? {
        let newRect = CGRect(x: 0, y: 0, width: targetSize.width, height: targetSize.height).integral
        UIGraphicsBeginImageContextWithOptions(newRect.size, false, 0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.interpolationQuality = .high
        draw(in: newRect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}

final class ProfileImageButton: BaseButton {

    private let size: CGSize

    init(size: CGSize = CGSize(width: 40, height: 40)) {
        self.size = size
        super.init(frame: .zero)

        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = Color.clear
        config.background.backgroundColor = Color.clear
        config.contentInsets = NSDirectionalEdgeInsets(
            top: 0, leading: 0, bottom: 0, trailing: 0
        )
        config.cornerStyle = .capsule
        config.image = UIImage(named: "profile")?.resize(targetSize: size)
        configuration = config
    }

    func updateImage(image: UIImage?) {
        configuration?.image = image?.resize(targetSize: size)
    }

}

final class ProfileNicknameButton: BaseButton {

    private let size: CGFloat

    init(size: CGFloat = 15) {
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
            attributes: AttributeContainer([.font: UIFont.systemFont(ofSize: size, weight: .bold)])
        )
        configuration = config
    }

    func updateTitle(title: String) {
        configuration?.attributedTitle = AttributedString(
            title,
            attributes: AttributeContainer([.font: UIFont.systemFont(ofSize: size, weight: .bold)])
        )
    }

}

final class BupInfoView: BaseView {
    private let hStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .top
        view.distribution = .fill
        view.spacing = 8
        return view
    }()
    let profileImageButton = ProfileImageButton()
    private let labelStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .top
        view.distribution = .equalSpacing
        view.spacing = 4
        return view
    }()
    let profileNicknameButton = ProfileNicknameButton()
    let phoneNumLabel = NicknameLabel()
    let titleLabel = BupTitleLabel()

    func reset() {
        profileImageButton.configuration?.image = nil
        profileNicknameButton.configuration?.title = nil
        phoneNumLabel.text = nil
        titleLabel.text = nil
    }

    override func initialAttributes() {
        super.initialAttributes()

        layer.cornerRadius = 16
        clipsToBounds = true
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }

    override func initialHierarchy() {
        super.initialHierarchy()

        [
            hStackView,
            titleLabel
        ].forEach { addSubview($0) }

        [
            profileImageButton,
            labelStackView
        ].forEach { hStackView.addArrangedSubview($0) }

        [
            profileNicknameButton,
            phoneNumLabel
        ].forEach { labelStackView.addArrangedSubview($0) }
    }

    override func initialLayout() {
        super.initialLayout()

        let offset = 16
        let inset = 16
        hStackView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(inset)
        }

        profileImageButton.snp.makeConstraints { make in
            make.size.equalTo(40)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageButton.snp.bottom).offset(offset)
            make.horizontalEdges.bottom.equalToSuperview().inset(inset)
        }
    }

}
