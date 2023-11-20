//
//  BaseButton.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/11/20.
//

import UIKit

class BaseButton: UIButton, Base {

    override init(frame: CGRect) {
        super.init(frame: frame)

        initialAttributes()
        initialHierarchy()
        initialLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initialAttributes() {}

    func initialHierarchy() {}

    func initialLayout() {}

}
