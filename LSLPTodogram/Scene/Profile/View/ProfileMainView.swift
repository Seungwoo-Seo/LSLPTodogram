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

    lazy var tableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.delegate = self
        view.sectionHeaderTopPadding = 0
        view.rowHeight = UITableView.automaticDimension
        view.register(ProfileCell.self, forCellReuseIdentifier: ProfileCell.identifier)
        view.register(BupSegmentHeader.self, forHeaderFooterViewReuseIdentifier: BupSegmentHeader.identifier)
        view.register(BupCell.self, forCellReuseIdentifier: BupCell.identifier)
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

extension ProfileMainView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let section = ProfileSection.allCases[section]
        switch section {
        case .profile:
            return nil
        case .bup:
            let header = tableView.dequeueReusableHeaderFooterView(
                withIdentifier: BupSegmentHeader.identifier
            ) as! BupSegmentHeader

            return header
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let section = ProfileSection.allCases[section]
        switch section {
        case .profile: return 0
        case .bup: return UITableView.automaticDimension
        }
    }

}
