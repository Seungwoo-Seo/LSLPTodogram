//
//  BupInputMainView.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/11/30.
//

import UIKit

final class BupInputMainView: BaseView {
    let backgroundImageView = {
        let view = UIImageView(image: UIImage(named: "fireBackground"))
        view.alpha = 0.7
        return view
    }()
    lazy var tableView = {
        let view = BaseTableView(frame: .zero, style: .plain)
        view.alwaysBounceVertical = false
        view.register(BupInputCell.self, forCellReuseIdentifier: BupInputCell.identifier)
        return view
    }()

    override func initialHierarchy() {
        super.initialHierarchy()

        addSubview(backgroundImageView)
        addSubview(tableView)
    }

    override func initialLayout() {
        super.initialLayout()

        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        tableView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }

}
