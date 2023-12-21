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
    let backgroundImageView = UIImageView(image: UIImage(named: "fireBackground"))
    lazy var tableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.backgroundColor = Color.clear
        view.rowHeight = UITableView.automaticDimension
        view.sectionHeaderTopPadding = 0
        view.separatorStyle = .none
        view.register(BupInfoInputCell.self, forCellReuseIdentifier: BupInfoInputCell.identifier)
        view.register(BupContentInputCell.self, forCellReuseIdentifier: BupContentInputCell.identifier)
        view.register(BupContentAddCell.self, forCellReuseIdentifier: BupContentAddCell.identifier)
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
