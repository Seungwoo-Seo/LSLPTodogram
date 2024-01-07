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

    private let viewModel: ProfileViewModel

    init(_ viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        let rowOfLikebutton = PublishRelay<Int>()

        let viewDidLoad = rx.sentMessage(#selector(UIViewController.viewDidLoad))
            .map { _ in Void() }
        let pull = mainView.tableView.refreshControl!.rx.controlEvent(.valueChanged).asObservable()

        let input = ProfileViewModel.Input(
            trigger: Observable.merge(viewDidLoad, pull),
            prefetchRows: mainView.tableView.rx.prefetchRows,
            rowOfLikebutton: rowOfLikebutton
        )
        let output = viewModel.transform(input: input)

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

                return cell

            case .bup(let item):
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: BupCell.identifier,
                    for: indexPath
                ) as! BupCell

                cell.configure(item: item)

                cell.imageUrls
                    .bind(to: cell.imageCollectionView.rx.items(cellIdentifier: ImageCell.identifier)) { index, string, cell in
                        guard let cell = cell as? ImageCell else {return}

                        cell.removeButton.isHidden = true
                        let token = KeychainManager.read(key: KeychainKey.token.rawValue) ?? ""
                        cell.imageView.requestModifier(with: string, token: token)
                    }
                    .disposed(by: cell.disposeBag)


                cell.communicationButtonStackView.likeButton.rx.tap
                    .withLatestFrom(Observable.just(indexPath.row))
                    .bind(to: rowOfLikebutton)
                    .disposed(by: cell.disposeBag)

                cell.communicationButtonStackView.commentButton.rx.tap
                    .bind(with: self) { owner, _ in
                        let vm = CommentViewModel(bup: item)
                        let vc = CommentViewController(vm)
                        let navi = UINavigationController(rootViewController: vc)
                        owner.present(navi, animated: true)
                    }
                    .disposed(by: cell.disposeBag)

                return cell
            }
        }

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

                var snapshot = NSDiffableDataSourceSnapshot<ProfileSection, ProfileItemIdentifiable>()
                snapshot.appendSections(ProfileSection.allCases)
                snapshot.appendItems(profiles, toSection: .profile)
                snapshot.appendItems(bups, toSection: .bup)
                owner.mainView.dataSource.apply(snapshot)
            }
            .disposed(by: disposeBag)

        output.fetching
            .drive(mainView.tableView.refreshControl!.rx.isRefreshing)
            .disposed(by: disposeBag)

        output.error
            .map { $0.description }
            .drive(rx.presentAlertToNetworkingErrorDescription)
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

private extension Reactive where Base: ProfileViewController {

    var presentAlertToNetworkingErrorDescription: Binder<String> {
        return Binder(base) { (vc, description) in
            let alert = UIAlertController(
                title: description,
                message: nil,
                preferredStyle: .alert
            )
            let confirm = UIAlertAction(
                title: "로그인 화면으로",
                style: .default
            ) { _ in
                vc.windowReset()
            }
            alert.addAction(confirm)
            vc.present(alert, animated: true)
        }
    }
}

private extension ProfileViewController {

    func windowReset() {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        sceneDelegate?.window?.rootViewController = LoginViewController()
        sceneDelegate?.window?.makeKeyAndVisible()
    }

    func presentProfileEditViewController() {
        let viewModel = ProfileEditViewModel()
        let vc = ProfileEditViewController(viewModel)
        let navi = UINavigationController(rootViewController: vc)
        present(navi, animated: true)
    }


}
