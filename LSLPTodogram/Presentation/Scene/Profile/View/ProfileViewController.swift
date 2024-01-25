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
    private let settingBarButtonItem = {
        let barButtonItem = UIBarButtonItem()
        barButtonItem.image = UIImage(systemName: "gearshape")
        barButtonItem.style = .plain
        return barButtonItem
    }()
    private let mainView = ProfileMainView()
    private let disposeBag = DisposeBag()

    private let viewModel: ProfileViewModel

    init(_ viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        let viewDidLoad = rx.sentMessage(#selector(UIViewController.viewDidLoad))
            .map { _ in Void() }
        let pull = mainView.tableView.refreshControl!.rx.controlEvent(.valueChanged).asObservable()
        // followers
        let didTapFollowersButton = PublishRelay<Void>()
        // followings
        let didTapFollowingsButton = PublishRelay<Void>()
        // like
        let rowOfLikebutton = PublishRelay<Int>()
        let didTapLikeButtonOfId = PublishRelay<String>()
        let likeState = PublishRelay<(row: Int, isSelected: Bool)>()

        let input = ProfileViewModel.Input(
            trigger: Observable.merge(viewDidLoad, pull),
            prefetchRows: mainView.tableView.rx.prefetchRows,
            didTapFollowersButton: didTapFollowersButton,
            didTapFollowingsButton: didTapFollowingsButton,
            rowOfLikebutton: rowOfLikebutton,
            didTapLikeButtonOfId: didTapLikeButtonOfId,
            likeState: likeState
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

                // 팔로워 버튼
                cell.followersButton.rx.tap
                    .bind(to: didTapFollowersButton)
                    .disposed(by: cell.disposeBag)

                // 팔로잉 버튼
                cell.followingButton.rx.tap
                    .bind(to: didTapFollowingsButton)
                    .disposed(by: cell.disposeBag)

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

                cell.configure(item: item, likeState: viewModel.likeState[indexPath.row])

                cell.imageUrls
                    .bind(to: cell.imageCollectionView.rx.items(cellIdentifier: ImageCell.identifier)) { index, string, cell in
                        guard let cell = cell as? ImageCell else {return}

                        cell.removeButton.isHidden = true
                        cell.imageView.requestModifier(with: string)
                    }
                    .disposed(by: cell.disposeBag)

                // 좋아요 버튼 누르면
                let didTapLikeButton = cell.communicationButtonStackView.likeButton.rx.tap
                    .scan(item.isIliked) { lastState, _ in !lastState } // isSelected 상태 토글
                    .flatMapLatest { isSelected in
                        Observable<Void>.create { observer in
                            // UI 업데이트
                            cell.communicationButtonStackView.likeButton.isSelected = isSelected
                            let countString = item.localLikesCountString(isSelected: isSelected)
                            cell.countButtonStackView.likeCountButton.updateTitle(title: countString)
                            observer.onNext(Void())
                            observer.onCompleted()
                            return Disposables.create()
                        }
                    }
                    .share()

                let rowAndIsSelected = Observable.combineLatest(
                    Observable.just(indexPath.row),
                    cell.communicationButtonStackView.likeButton.rx.observe(\.isSelected)
                )

                // 이벤트가 발생한 좋아요 버튼의 정보를 viewModel로 전달
                didTapLikeButton
                    .withLatestFrom(rowAndIsSelected)
                    .bind(with: self) { owner, rowAndIsSelected in
                        likeState.accept(rowAndIsSelected)
                    }
                    .disposed(by: cell.disposeBag)

                // 무분별한 API request를 방지하기 위해 throttle operator 사용
                didTapLikeButton
                    .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
                    .withLatestFrom(Observable.just(item.id))
                    .bind(to: didTapLikeButtonOfId)
                    .disposed(by: cell.disposeBag)

                cell.communicationButtonStackView.commentButton.rx.tap
                    .bind(with: self) { owner, _ in
                        let vm = CommentViewModel(bup: item)
                        let vc = CommentViewController(vm)
                        let navi = UINavigationController(rootViewController: vc)
                        owner.present(navi, animated: true)
                    }
                    .disposed(by: cell.disposeBag)

                cell.countButtonStackView.commentCountButton.rx.tap
                    .bind(with: self) { owner, _ in
                        let vm = BupDetailViewModel(postId: item.id, hostId: item.hostID)
                        let vc = BupDetailViewController(vm)
                        owner.navigationController?.pushViewController(vc, animated: true)
                    }
                    .disposed(by: cell.disposeBag)

                return cell

            case .empty(let placeholder):
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: EmptyCell.identifier,
                    for: indexPath
                ) as! EmptyCell

                cell.configure(placeholder: placeholder)

                return cell
            }
        }

        output.items
            .bind(with: self) { owner, items in
                var profiles: [ProfileItemIdentifiable] = []
                var bups: [ProfileItemIdentifiable] = []
                var placeholders: [ProfileItemIdentifiable] = []

                for item in items {
                    switch item {
                    case .profile(let profile):
                        profiles.append(ProfileItemIdentifiable.profile(profile))
                    case .bup(let bup):
                        bups.append(ProfileItemIdentifiable.bup(bup))
                    case .empty(let placeholder):
                        placeholders.append(ProfileItemIdentifiable.empty(placeholder))
                    }
                }

                var snapshot = NSDiffableDataSourceSnapshot<ProfileSection, ProfileItemIdentifiable>()
                snapshot.appendSections(ProfileSection.allCases)
                snapshot.appendItems(profiles, toSection: .profile)
                snapshot.appendItems(bups, toSection: .bup)
                owner.mainView.dataSource.apply(snapshot)
            }
            .disposed(by: disposeBag)

        output.changedSegmentItems
            .bind(with: self) { owner, items in
                var snapshot = owner.mainView.dataSource.snapshot()
                snapshot.deleteSections([.bup])
                snapshot.appendSections([.bup])
                snapshot.appendItems(items, toSection: .bup)
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

        output.followers
            .emit(with: self) { owner, followers in
                let vm = FollowerListViewModel(followers: followers)
                let vc = FollowerListViewController(vm)
                let navi = UINavigationController(rootViewController: vc)
                owner.present(navi, animated: true)
            }
            .disposed(by: disposeBag)

        output.followings
            .emit(with: self) { owner, followings in
                let vm = FollowingListViewModel(followings: followings)
                let vc = FollowingListViewController(vm)
                let navi = UINavigationController(rootViewController: vc)
                owner.present(navi, animated: true)
            }
            .disposed(by: disposeBag)

        settingBarButtonItem.rx.tap
            .bind(with: self) { owner, _ in
                let vc = SettingViewController()
                owner.navigationController?.pushViewController(vc, animated: true)
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
        navigationController?.navigationBar.tintColor = Color.black
        navigationItem.backButtonTitle = ""
    }

    override func initialHierarchy() {
        super.initialHierarchy()

        navigationItem.rightBarButtonItem = settingBarButtonItem
    }

}

extension ProfileViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let item = viewModel.items.value[indexPath.row + 1]
        if case .bup(let bup) = item {
            let vm = BupDetailViewModel(postId: bup.id, hostId: bup.creator.id)
            let vc = BupDetailViewController(vm)
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let section = ProfileSection.allCases[section]
        switch section {
        case .profile:
            return nil
        case .bup:
            let header = tableView.dequeueReusableHeaderFooterView(
                withIdentifier: BupSegmentHeader.identifier
            ) as! BupSegmentHeader

            header.underlineSegmentedControl.rx.selectedSegmentIndex
                .bind(to: viewModel.segmentIndex)
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

    func presentProfileEditViewController() {
        let viewModel = ProfileEditViewModel()
        let vc = ProfileEditViewController(viewModel)
        let navi = UINavigationController(rootViewController: vc)
        present(navi, animated: true)
    }


}
