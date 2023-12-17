//
//  CommentMainView.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/14.
//

import UIKit

enum CommentItemIdentifiable: Hashable {
    case bup(Bup)
    case comment(Profile)
}

final class CommentMainView: BaseView {
    lazy var tableView = {
        let view = CommentTableView(frame: .zero, style: .plain)
        view.sectionHeaderTopPadding = 0
        view.rowHeight = UITableView.automaticDimension
        view.sectionFooterHeight = UITableView.automaticDimension
        view.estimatedSectionFooterHeight = 44
        view.register(BupCell.self, forCellReuseIdentifier: BupCell.identifier)
        view.register(CommentCell.self, forCellReuseIdentifier: CommentCell.identifier)
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
