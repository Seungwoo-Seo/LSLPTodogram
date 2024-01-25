//
//  ProfileMainView.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/11.
//

import UIKit

enum ProfileSection: Int, CaseIterable {
    case profile
    case bup
}

enum ProfileItemIdentifiable: Hashable {
    case profile(Profile)
    case bup(Bup)
    case empty(String)
}

final class ProfileMainView: BaseView {
    var dataSource: UITableViewDiffableDataSource<ProfileSection, ProfileItemIdentifiable>!

    let backgroundImageView = {
        let view = UIImageView(image: UIImage(named: "fireBackground"))
        view.alpha = 0.7
        return view
    }()
    let refresh = {
        return UIRefreshControl()
    }()
    lazy var tableView = {
        let view = BaseTableView(frame: .zero, style: .plain)
        view.register(ProfileCell.self, forCellReuseIdentifier: ProfileCell.identifier)
        view.register(BupSegmentHeader.self, forHeaderFooterViewReuseIdentifier: BupSegmentHeader.identifier)
        view.register(BupCell.self, forCellReuseIdentifier: BupCell.identifier)
        view.register(EmptyCell.self, forCellReuseIdentifier: EmptyCell.identifier)
        view.refreshControl = refresh
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
