//
//  CommentMainView.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/14.
//

import UIKit

enum CommentSection: Int, CaseIterable {
    case bup
    case comment
}

enum CommentItemIdentifiable: Hashable {
    case bup(Bup)
    case comment(Comment)
}

class Comment: Hashable {
    var text: String

    let id = UUID()

    init(text: String) {
        self.text = text
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Comment, rhs: Comment) -> Bool {
        return lhs.id == rhs.id
    }

}

final class CommentMainView: BaseView {
    var dataSource: UITableViewDiffableDataSource<CommentSection, CommentItemIdentifiable>!
    var snapshot = NSDiffableDataSourceSnapshot<CommentSection, CommentItemIdentifiable>()

    lazy var tableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.sectionHeaderTopPadding = 0
        view.rowHeight = UITableView.automaticDimension
        view.register(BupCell.self, forCellReuseIdentifier: BupCell.identifier)
        return view
    }()

}
