//
//  OthersProfileMainView.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/19.
//

import UIKit

enum OthersProfileSection: Int, CaseIterable {
    case profile
    case bup
}

enum OthersProfileItemIdentifiable: Hashable {
    case profile(OthersProfile)
    case bup(Bup)
}

final class OthersProfileMainView: BaseView {
    let backgroundImageView = UIImageView(image: UIImage(named: "fireBackground"))
    var dataSource: UITableViewDiffableDataSource<OthersProfileSection, OthersProfileItemIdentifiable>!
    var snapshot = NSDiffableDataSourceSnapshot<OthersProfileSection, OthersProfileItemIdentifiable>()    // 섹션은 어차피 안바뀔거임!

    lazy var tableView = {
        let view = BaseTableView(frame: .zero, style: .plain)
        view.register(OthersProfileCell.self, forCellReuseIdentifier: OthersProfileCell.identifier)
        view.register(BupSegmentHeader.self, forHeaderFooterViewReuseIdentifier: BupSegmentHeader.identifier)
        view.register(BupCell.self, forCellReuseIdentifier: BupCell.identifier)
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
