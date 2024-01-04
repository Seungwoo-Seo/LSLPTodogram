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
}

final class ProfileMainView: BaseView {
    var dataSource: UITableViewDiffableDataSource<ProfileSection, ProfileItemIdentifiable>!
    var snapshot = NSDiffableDataSourceSnapshot<ProfileSection, ProfileItemIdentifiable>()    // 섹션은 어차피 안바뀔거임!

    let backgroundImageView = UIImageView(image: UIImage(named: "fireBackground"))
    lazy var tableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.backgroundColor = Color.clear
        view.sectionHeaderTopPadding = 0
        view.rowHeight = UITableView.automaticDimension
        view.separatorStyle = .none
        view.register(ProfileCell.self, forCellReuseIdentifier: ProfileCell.identifier)
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
