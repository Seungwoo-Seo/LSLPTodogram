//
//  BupFooter.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/11/30.
//

import UIKit

final class BupFooter: BaseCollectionReusableView {
    private let buttonStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .fillEqually
        view.spacing = 8
        return view
    }()
    let likeButton = {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = Color.black
        config.image = UIImage(systemName: "heart")
        let button = UIButton(configuration: config)
        return button
    }()
    let commentButton = {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = Color.black
        config.image = UIImage(systemName: "message")
        let button = UIButton(configuration: config)
        return button
    }()

    func configure(_ item: BupBottom) {

    }

    override func initialAttributes() {
        super.initialAttributes()

        backgroundColor = Color.green
        layer.cornerRadius = 16
        clipsToBounds = true
        layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }

    override func initialHierarchy() {
        super.initialHierarchy()

        addSubview(buttonStackView)

        [
            likeButton,
            commentButton
        ].forEach { buttonStackView.addArrangedSubview($0) }
    }

    override func initialLayout() {
        super.initialLayout()

        let inset = 16
        buttonStackView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.leading.equalToSuperview().inset(inset)
            make.height.equalTo(44)
        }
    }

}
