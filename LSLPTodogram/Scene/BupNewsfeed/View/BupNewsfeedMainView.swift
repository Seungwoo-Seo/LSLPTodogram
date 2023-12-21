//
//  BupNewsfeedMainView.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/12.
//

import UIKit

final class BupNewsfeedMainView: BaseView {
    let refresh = UIRefreshControl()
    let backgroundImageView = UIImageView(image: UIImage(named: "fireBackground"))
    lazy var tableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.backgroundColor = Color.clear
        view.sectionHeaderTopPadding = 0
        view.separatorStyle = .none
        view.rowHeight = UITableView.automaticDimension
//        view.refreshControl = refresh
        view.register(BupCell.self, forCellReuseIdentifier: BupCell.identifier)
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
