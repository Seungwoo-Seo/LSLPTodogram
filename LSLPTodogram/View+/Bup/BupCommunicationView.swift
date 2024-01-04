//
//  BupCommunicationView.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/12.
//

import UIKit

final class BupCommunicationView: BaseView {
    private lazy var buttonStackView = {
        let view = UIStackView(arrangedSubviews: [likeButton, commentButton])
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .fillEqually
        view.spacing = 16
        return view
    }()
    let likeButton = {
        var config = UIButton.Configuration.plain()
        config.background.backgroundColor = Color.clear
        config.preferredSymbolConfigurationForImage = .init(pointSize: 15, weight: .bold)
        config.contentInsets = NSDirectionalEdgeInsets(
            top: 8,
            leading: 0,
            bottom: 8,
            trailing: 0
        )
        let button = UIButton(configuration: config)
        button.configurationUpdateHandler = { button in
            switch button.state {
            case .selected:
                button.configuration?.baseForegroundColor = Color.red
                button.configuration?.image = UIImage(systemName: "heart.fill")
            default:
                button.configuration?.baseForegroundColor = Color.black
                button.configuration?.image = UIImage(systemName: "heart")
            }
        }
        return button
    }()
    let commentButton = {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = Color.black
        config.background.backgroundColor = Color.clear
        config.image = UIImage(systemName: "message")
        config.preferredSymbolConfigurationForImage = .init(pointSize: 15, weight: .bold)
        config.contentInsets = NSDirectionalEdgeInsets(
            top: 8,
            leading: 0,
            bottom: 8,
            trailing: 0
        )
        let button = UIButton(configuration: config)
        return button
    }()

    lazy var vStackView = {
        let view = UIStackView(arrangedSubviews: [hStackView])
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = 0
        return view
    }()
    lazy var hStackView = {
        let view = UIStackView(arrangedSubviews: [commentCountButton, likeCountButton])
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .fillProportionally
        view.spacing = 16
        return view
    }()
    let commentCountButton = {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = Color.lightGray
        config.background.backgroundColor = Color.clear
        config.title = "0 답글"
        config.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 0,
            bottom: 0,
            trailing: 0
        )
        let button = UIButton(configuration: config)
        return button
    }()
    let likeCountButton = {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = Color.lightGray
        config.background.backgroundColor = Color.clear
        config.title = "0 좋아요"
        config.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 0,
            bottom: 0,
            trailing: 0
        )
        let button = UIButton(configuration: config)
        return button
    }()


    override func initialAttributes() {
        super.initialAttributes()

        backgroundColor = Color.green
        layer.cornerRadius = 16
        clipsToBounds = true
        layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }

    override func initialHierarchy() {
        super.initialHierarchy()

        [buttonStackView, vStackView].forEach { addSubview($0) }
    }

    override func initialLayout() {
        super.initialLayout()

        let offset = 4
        let inset = 16
        buttonStackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().inset(inset-3)
        }

        vStackView.snp.makeConstraints { make in
            make.top.equalTo(buttonStackView.snp.bottom).offset(offset)
            make.leading.equalToSuperview().inset(inset)
            make.bottom.equalToSuperview().inset(inset)
        }
    }
}
