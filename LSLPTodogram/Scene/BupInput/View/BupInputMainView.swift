//
//  BupInputMainView.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/11/30.
//

import UIKit

enum BupInputItemIdentifiable: Hashable {
    case info(BupInfoInput)
    case content(BupContentInput)
    case add
}

final class BupInputMainView: BaseView {
    lazy var tableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.rowHeight = UITableView.automaticDimension
        view.estimatedRowHeight = 44
        view.sectionHeaderTopPadding = 0
        view.register(BupInfoInputCell.self, forCellReuseIdentifier: BupInfoInputCell.identifier)
        view.register(BupContentInputCell.self, forCellReuseIdentifier: BupContentInputCell.identifier)
        view.register(BupContentAddCell.self, forCellReuseIdentifier: BupContentAddCell.identifier)
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
