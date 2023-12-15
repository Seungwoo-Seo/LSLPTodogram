//
//  BupNewsfeedMainView.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/12.
//

import UIKit

enum BupNewsfeedSection: Int, CaseIterable {
    case bup
}

final class BupNewsfeedMainView: BaseView {
    var dataSource: UITableViewDiffableDataSource<BupNewsfeedSection, Bup>!
    var snapshot = NSDiffableDataSourceSnapshot<BupNewsfeedSection, Bup>()

    lazy var tableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.sectionHeaderTopPadding = 0
        view.rowHeight = UITableView.automaticDimension
        view.register(BupCell.self, forCellReuseIdentifier: BupCell.identifier)
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
