//
//  CountButtonStackView.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/24.
//

import UIKit

final class CountButtonStackView: BaseStackView {
    private lazy var hstackView = {
        let view = UIStackView(arrangedSubviews: [likeCountButton, commentCountButton])
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .fillEqually
        view.spacing = 8
        return view
    }()
    let likeCountButton = CountButton()
    let commentCountButton = CountButton()

    override func initialAttributes() {
        super.initialAttributes()

        axis = .vertical
        alignment = .fill
        distribution = .fill
        spacing = 0
    }

    override func initialHierarchy() {
        super.initialHierarchy()

        addArrangedSubview(hstackView)
    }
}
