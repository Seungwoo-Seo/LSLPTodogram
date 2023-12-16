//
//  ProfileViewController.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/10.
//

import UIKit
import RxCocoa
import RxSwift

final class ProfileViewController: BaseViewController {
    private let mainView = ProfileMainView()
    private let disposeBag = DisposeBag()

    init(_ viewModel: ProfileViewModel) {
        super.init(nibName: nil, bundle: nil)

        mainView.dataSource = UITableViewDiffableDataSource(
            tableView: mainView.tableView
        ) { tableView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .profile(let profile):
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: ProfileCell.identifier,
                    for: indexPath
                ) as! ProfileCell

                cell.configure(profile)

                cell.profileEditButton.rx.tap
                    .bind(with: self) { owner, _ in
                        owner.presentProfileEditViewController()
                    }
                    .disposed(by: cell.disposeBag)

//                cell.profileShareButton

                return cell

            case .bup(let bup):
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: BupCell.identifier,
                    for: indexPath
                ) as! BupCell

                let infoView = cell.bupView.infoView
                infoView.profileImageView.image = UIImage(systemName: "person")
                infoView.nicknameLabel.text = bup.nick
                infoView.titleLabel.text = bup.title

                cell.bupView.contentView0.bupContentLabel.text = bup.content0
                cell.bupView.contentView1.bupContentLabel.text = bup.content1
                cell.bupView.contentView2.bupContentLabel.text = bup.content2

                let contentStackView = cell.bupView.contentStackView
                for subview in contentStackView.arrangedSubviews {
                    if let contentView = subview as? BupContentView {
                        if !(contentView.bupContentLabel.text!.isEmpty) {
                            contentView.isHidden = false
                        } else {
                            contentView.isHidden = true
                        }
                    }
                }

                return cell
            }
        }

        mainView.snapshot.appendSections(ProfileSection.allCases)
        mainView.dataSource.apply(mainView.snapshot)

        let input = ProfileViewModel.Input()
        let output = viewModel.transform(input: input)

        output.items
            .bind(with: self) { owner, items in
                var profiles: [ProfileItemIdentifiable] = []
                var bups: [ProfileItemIdentifiable] = []

                for item in items {
                    switch item {
                    case .profile(let profile):
                        profiles.append(ProfileItemIdentifiable.profile(profile))
                    case .bup(let bup):
                        bups.append(ProfileItemIdentifiable.bup(bup))
                    }
                }

                owner.mainView.snapshot.appendItems(profiles, toSection: .profile)
                owner.mainView.snapshot.appendItems(bups, toSection: .bup)
                owner.mainView.dataSource.apply(owner.mainView.snapshot)
            }
            .disposed(by: disposeBag)
    }

    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func initialAttributes() {
        super.initialAttributes()

        mainView.tableView.delegate = self
    }

}

extension ProfileViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let section = ProfileSection.allCases[section]
        switch section {
        case .profile:
            return nil
        case .bup:
            let header = tableView.dequeueReusableHeaderFooterView(
                withIdentifier: BupSegmentHeader.identifier
            ) as! BupSegmentHeader

            header.activeBupButton.rx.tap
                .bind(with: self) { owner, _ in

                }
                .disposed(by: header.disposeBag)

            header.historyBupButton.rx.tap
                .bind(with: self) { owner, _ in
//                    owner.presentProfileEditViewController()
                }
                .disposed(by: header.disposeBag)

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

private extension ProfileViewController {

    func presentProfileEditViewController() {
        let viewModel = ProfileEditViewModel()
        let vc = ProfileEditViewController(viewModel)
        let navi = UINavigationController(rootViewController: vc)
        present(navi, animated: true)
    }


}
