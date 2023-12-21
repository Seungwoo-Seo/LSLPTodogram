//
//  BupView.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/11.
//

import UIKit

final class BupView: BaseView {
    let infoView = BupInfoView()

    let contentView0 = BupContentView()
    let contentView1 = BupContentView()
    let contentView2 = BupContentView()
    lazy var contentViews = [
        contentView0,
        contentView1,
        contentView2
    ]
    lazy var contentStackView = {
        let view = UIStackView(arrangedSubviews: contentViews)
        view.axis = .vertical
        view.distribution = .fillProportionally
        view.alignment = .fill
        view.spacing = 1
        return view
    }()

    lazy var tStackView = {
        let view = UIStackView(arrangedSubviews: [communicationView])
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = 0
        return view
    }()
    let communicationView = BupCommunicationView()

    override func initialAttributes() {
        super.initialAttributes()

        backgroundColor = Color.clear
    }

    override func initialHierarchy() {
        super.initialHierarchy()

        [
            infoView,
            contentStackView,
            tStackView
        ].forEach { addSubview($0) }
    }

    override func initialLayout() {
        super.initialLayout()

        infoView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }

        contentStackView.snp.makeConstraints { make in
            make.top.equalTo(infoView.snp.bottom).offset(1)
            make.horizontalEdges.equalToSuperview()
        }

        tStackView.snp.makeConstraints { make in
            make.top.equalTo(contentStackView.snp.bottom).offset(1)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }

}
