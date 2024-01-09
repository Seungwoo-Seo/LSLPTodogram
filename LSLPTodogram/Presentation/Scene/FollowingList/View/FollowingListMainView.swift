//
//  FollowingListMainView.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2024/01/09.
//

import UIKit

final class FollowingListMainView: BaseView {
    let backgroundImageView = {
        let view = UIImageView(image: UIImage(named: "fireBackground"))
        view.alpha = 0.7
        return view
    }()
//    let refresh = {
//        return UIRefreshControl()
//    }()
    lazy var tableView = {
        let view = BaseTableView(frame: .zero, style: .plain)
        view.register(FollowingListCell.self, forCellReuseIdentifier: FollowingListCell.identifier)
//        view.refreshControl = refresh
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

