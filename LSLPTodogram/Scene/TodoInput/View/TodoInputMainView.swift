//
//  TodoInputMainView.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/11/30.
//

import UIKit

final class TodoInputMainView: BaseView {
    lazy var tableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.rowHeight = UITableView.automaticDimension
        view.estimatedRowHeight = 44
        view.register(TodoInfoInputCell.self, forCellReuseIdentifier: TodoInfoInputCell.identifier)
        view.register(TodoInputCell.self, forCellReuseIdentifier: TodoInputCell.identifier)
        view.register(TodoAddCell.self, forCellReuseIdentifier: TodoAddCell.identifier)
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
