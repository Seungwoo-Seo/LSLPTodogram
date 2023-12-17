//
//  BupNewsfeedMainView.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/12.
//

import UIKit

final class BupNewsfeedMainView: BaseView {
    let tableView = BupNewsfeedTableView(frame: .zero, style: .plain)

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
