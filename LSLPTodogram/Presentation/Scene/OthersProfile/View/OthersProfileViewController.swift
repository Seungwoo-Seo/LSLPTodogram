//
//  OthersProfileViewController.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/19.
//

import UIKit
import RxCocoa
import RxSwift

final class OthersProfileViewController: BaseViewController {
    private let mainView = OthersProfileMainView()
    private let disposeBag = DisposeBag()

    private let viewModel: OthersProfileViewModel

    init(_ viewModel: OthersProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        let itemOfFollowButton = PublishRelay<OthersProfile>()

        let input = OthersProfileViewModel.Input(
            itemOfFollowButton: itemOfFollowButton
        )
        let output = viewModel.transform(input: input)

        mainView.dataSource = UITableViewDiffableDataSource(
            tableView: mainView.tableView
        ) { tableView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .profile(let item):
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: OthersProfileCell.identifier,
                    for: indexPath
                ) as! OthersProfileCell

                cell.configure(item)

                cell.followButton.rx.tap
                    .withLatestFrom(Observable.just(item))
                    .bind(to: itemOfFollowButton)
                    .disposed(by: cell.disposeBag)

                output.followState
                    .bind(to: cell.followButton.rx.isSelected)
                    .disposed(by: cell.disposeBag)

                return cell

            case .bup(let bup):
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: BupCell.identifier,
                    for: indexPath
                ) as! BupCell

                cell.profileImageButton.configuration?.image = UIImage(systemName: "person")
                cell.profileNicknameButton.configuration?.title = bup.creator.nick
                cell.contentLabel.text = bup.content
                
                return cell
            }
        }

        mainView.snapshot.appendSections(OthersProfileSection.allCases)
        mainView.dataSource.apply(mainView.snapshot)

        output.items
            .bind(with: self) { owner, items in
                var profiles: [OthersProfileItemIdentifiable] = []
                var bups: [OthersProfileItemIdentifiable] = []

                for item in items {
                    switch item {
                    case .profile(let profile):
                        profiles.append(OthersProfileItemIdentifiable.profile(profile))
                    case .bup(let bup):
                        bups.append(OthersProfileItemIdentifiable.bup(bup))
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

extension OthersProfileViewController: UITableViewDelegate {

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
        let section = OthersProfileSection.allCases[section]
        switch section {
        case .profile: return 0
        case .bup: return UITableView.automaticDimension
        }
    }

}
