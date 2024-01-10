//
//  BupNewsfeedViewController.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/11/28.
//

import UIKit
import RxCocoa
import RxSwift

final class BupNewsfeedViewController: BaseViewController {
    private let mainView = BupNewsfeedMainView()
    private let disposeBag = DisposeBag()

    private let viewModel: BupNewsfeedViewModel

    init(_ viewModel: BupNewsfeedViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        let viewDidLoad = rx.sentMessage(#selector(UIViewController.viewDidLoad))
            .map { _ in Void() }

        let pull = mainView.tableView.refreshControl!.rx
            .controlEvent(.valueChanged)
            .asObservable()

        let postCreatorId = PublishRelay<String>()

        // like
        let rowOfLikebutton = PublishRelay<Int>()
        let didTapLikeButtonOfId = PublishRelay<String>()
        let likeState = PublishRelay<(row: Int, isSelected: Bool)>()

        let input = BupNewsfeedViewModel.Input(
            trigger: Observable.merge(viewDidLoad, pull),
            prefetchRows: mainView.tableView.rx.prefetchRows,
            postCreatorId: postCreatorId,
            rowOfLikebutton: rowOfLikebutton,
            didTapLikeButtonOfId: didTapLikeButtonOfId,
            likeState: likeState
        )
        let output = viewModel.transform(input: input)

        output.items
            .bind(to: mainView.tableView.rx.items) { tv, row, item in
                guard let cell = tv.dequeueReusableCell(
                    withIdentifier: BupCell.identifier
                ) as? BupCell else {return UITableViewCell()}

                cell.configure(item: item, likeState: viewModel.likeState[row])

                cell.imageUrls
                    .bind(to: cell.imageCollectionView.rx.items(cellIdentifier: ImageCell.identifier)) { index, string, cell in
                        guard let cell = cell as? ImageCell else {return}

                        cell.removeButton.isHidden = true
                        cell.imageView.requestModifier(with: string)
                    }
                    .disposed(by: cell.disposeBag)

                Observable
                    .merge(
                        cell.profileImageButton.rx.tap.asObservable(),
                        cell.profileNicknameButton.rx.tap.asObservable()
                    )
                    .withLatestFrom(Observable.just(item.creator.id))
                    .bind(to: postCreatorId)
                    .disposed(by: cell.disposeBag)

                // MARK: - ellipsis
                cell.ellipsisButton.rx.tap
                    .withLatestFrom(Observable.zip(Observable.just(row), Observable.just(item)))
                    .bind(with: self) { owner, cellInfo in
                        if item.creator.id == item.hostID {
                            let vm = EllipsisViewModel(cellInfo: cellInfo)
                            let vc = EllipsisViewController(vm)
                            owner.presentPanModal(vc)
                        } else {
                            let vm = OthersEllipsisViewModel(cellInfo: cellInfo)
                            let vc = OthersEllipsisViewController(vm)
                            owner.presentPanModal(vc)
                        }
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
                    Observable.just(row),
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
            }
            .disposed(by: disposeBag)

        mainView.tableView.rx.modelSelected(Bup.self)
            .bind(with: self) { owner, bup in
                let vm = BupDetailViewModel(postId: bup.id, hostId: bup.hostID)
                let vc = BupDetailViewController(vm)
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)

        output.postCreatorState
            .bind(with: self) { owner, postCreatorState in
                if postCreatorState.isMine {
                    let vm = ProfileViewModel()
                    let vc = ProfileViewController(vm)
                    owner.navigationController?.pushViewController(vc, animated: true)
                } else {
                    let vm = OthersProfileViewModel(othersId: postCreatorState.id)
                    let vc = OthersProfileViewController(vm)
                    owner.navigationController?.pushViewController(vc, animated: true)
                }
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

    override func initialHierarchy() {
        super.initialHierarchy()

        let label = UILabel()
        label.text = "Bupgram"
        label.textColor = Color.white
        label.font = UIFont(name: "Marker Felt Thin", size: 40)
        let leftBarButtonItem = UIBarButtonItem(customView: label)
        navigationItem.leftBarButtonItem = leftBarButtonItem
    }

}

private extension Reactive where Base: BupNewsfeedViewController {

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

private extension BupNewsfeedViewController {

    func windowReset() {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        sceneDelegate?.window?.rootViewController = LoginViewController()
        sceneDelegate?.window?.makeKeyAndVisible()
    }

}
