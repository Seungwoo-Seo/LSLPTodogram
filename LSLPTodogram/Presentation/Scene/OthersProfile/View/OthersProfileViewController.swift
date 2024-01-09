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

        let viewDidLoad = rx.sentMessage(#selector(UIViewController.viewDidLoad))
            .map { _ in Void() }
        let pull = mainView.tableView.refreshControl!.rx.controlEvent(.valueChanged).asObservable()
        // followers
        let didTapFollowersButton = PublishRelay<Void>()
        // followings
        let didTapFollowingsButton = PublishRelay<Void>()
        // follow
        let followState = PublishRelay<(othersID: String, isSelected: Bool)>()
        // like
        let rowOfLikebutton = PublishRelay<Int>()
        let didTapLikeButtonOfId = PublishRelay<String>()
        let likeState = PublishRelay<(row: Int, isSelected: Bool)>()

        let input = OthersProfileViewModel.Input(
            trigger: Observable.merge(viewDidLoad, pull),
            prefetchRows: mainView.tableView.rx.prefetchRows,
            didTapFollowersButton: didTapFollowersButton,
            didTapFollowingsButton: didTapFollowingsButton,
            followState: followState,
            rowOfLikebutton: rowOfLikebutton,
            didTapLikeButtonOfId: didTapLikeButtonOfId,
            likeState: likeState
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

                // 팔로워 버튼
                cell.followersButton.rx.tap
                    .bind(to: didTapFollowersButton)
                    .disposed(by: cell.disposeBag)

                // 팔로잉 버튼
                cell.followingButton.rx.tap
                    .bind(to: didTapFollowingsButton)
                    .disposed(by: cell.disposeBag)

                // 팔로우 버튼 누르면
                let didTapFollowButton = cell.followButton.rx.tap
                    .scan(cell.followButton.isSelected) { lastState, _ in !lastState } // isSelected 상태 토글
                    .flatMapLatest { isSelected in
                        Observable<Void>.create { observer in
                            // UI 업데이트
                            cell.followButton.isSelected = isSelected
                            cell.followButton.configuration?.title = item.localFollowStateToString(isSelected: isSelected)
                            cell.followersButton.updateTitle(item.localFollowersCountToString(isSelected: isSelected))
                            observer.onNext(Void())
                            observer.onCompleted()
                            return Disposables.create()
                        }
                    }
                    .share()

                didTapFollowButton
                    .debug()
                    .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
                    .withLatestFrom(cell.followButton.rx.observe(\.isSelected))
                    .bind(with: self) { owner, isSelected in
                        followState.accept((item.id, isSelected))
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
                var profiles: [OthersProfileItemIdentifiable] = []
                var bups: [OthersProfileItemIdentifiable] = []
                var placeholders: [OthersProfileItemIdentifiable] = []

                for item in items {
                    switch item {
                    case .profile(let profile):
                        profiles.append(OthersProfileItemIdentifiable.profile(profile))
                    case .bup(let bup):
                        bups.append(OthersProfileItemIdentifiable.bup(bup))
                    case .empty(let placeholder):
                        placeholders.append(OthersProfileItemIdentifiable.empty(placeholder))
                    }
                }

                var snapshot = NSDiffableDataSourceSnapshot<OthersProfileSection, OthersProfileItemIdentifiable>()
                snapshot.appendSections(OthersProfileSection.allCases)
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

        output.changedSegmentItems
            .bind(with: self) { owner, items in
                var snapshot = owner.mainView.dataSource.snapshot()
                snapshot.deleteSections([.bup])
                snapshot.appendSections([.bup])
                snapshot.appendItems(items, toSection: .bup)
                owner.mainView.dataSource.apply(snapshot)
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
                withIdentifier: OthersBupSegmentHeader.identifier
            ) as! OthersBupSegmentHeader

            header.underlineSegmentedControl.rx.selectedSegmentIndex
                .bind(to: viewModel.segmentIndex)
                .disposed(by: header.disposeBag)

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

private extension Reactive where Base: OthersProfileViewController {

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

private extension OthersProfileViewController {

    func windowReset() {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        sceneDelegate?.window?.rootViewController = LoginViewController()
        sceneDelegate?.window?.makeKeyAndVisible()
    }

}
