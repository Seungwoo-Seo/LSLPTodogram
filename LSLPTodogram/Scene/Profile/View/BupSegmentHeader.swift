//
//  BupSegmentHeader.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/12.
//

import UIKit
import RxSwift

final class BupSegmentHeader: BaseTableViewHeaderFooterView {
    var disposeBag = DisposeBag()

    private lazy var hStackView = {
        let view = UIStackView(arrangedSubviews: [activeBupButton, historyBupButton])
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.alignment = .fill
        view.spacing = 0
        return view
    }()
    let activeBupButton = {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = Color.black
        config.background.backgroundColor = Color.clear
        config.title = "Active"
        let button = UIButton(configuration: config)
        return button
    }()
    let historyBupButton = {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = Color.black
        config.background.backgroundColor = Color.clear
        config.title = "History"
        let button = UIButton(configuration: config)
        return button
    }()

    override func prepareForReuse() {
        super.prepareForReuse()

        disposeBag = DisposeBag()
    }

    override func initialHierarchy() {
        super.initialHierarchy()

        addSubview(hStackView)
    }

    override func initialLayout() {
        super.initialLayout()

        hStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(44)
        }
    }
}
