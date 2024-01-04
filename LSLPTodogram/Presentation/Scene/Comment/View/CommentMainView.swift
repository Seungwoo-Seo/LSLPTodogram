//
//  CommentMainView.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/14.
//

import UIKit

enum CommentItemIdentifiable: Hashable {
    case commentOwner(Bup)
    case comment(Profile)
}

final class CommentMainView: BaseView {
    let backgroundImageView = {
        let view = UIImageView(image: UIImage(named: "fireBackground"))
        view.alpha = 0.7
        return view
    }()
    lazy var tableView = {
        let view = CommentTableView(frame: .zero, style: .plain)
        view.register(CommentOwnerCell.self, forCellReuseIdentifier: CommentOwnerCell.identifier)
        view.register(CommentCell.self, forCellReuseIdentifier: CommentCell.identifier)
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
