//
//  OthersEllipsisMainView.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2024/01/10.
//

import UIKit

final class OthersEllipsisMainView: BaseView {
    let tableView = {
        let view = BaseTableView(frame: .zero, style: .insetGrouped)
        view.isScrollEnabled = false
        view.rowHeight = 44
        view.separatorColor = Color.lightGray.withAlphaComponent(0.4)
        view.register(OthersEllipsisCell.self, forCellReuseIdentifier: OthersEllipsisCell.identifier)
        return view
    }()

    override func initialHierarchy() {
        super.initialHierarchy()

        addSubview(tableView)
    }

    override func initialLayout() {
        super.initialLayout()

        tableView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }
}


