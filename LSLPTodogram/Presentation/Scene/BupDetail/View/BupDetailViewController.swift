//
//  BupDetailViewController.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2024/01/09.
//

import UIKit
import RxCocoa
import RxSwift

final class BupDetailViewController: BaseViewController {
    private let disposeBag = DisposeBag()

    private let mainView = BupDetailMainView()

    private let viewModel: BupDetailViewModel

    init(_ viewModel: BupDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        let viewDidLoad = rx.sentMessage(#selector(UIViewController.viewDidLoad))
            .map { _ in Void() }
        let pull = mainView.tableView.refreshControl!.rx.controlEvent(.valueChanged).asObservable()
        // like
        let rowOfLikebutton = PublishRelay<Int>()
        let didTapLikeButtonOfId = PublishRelay<String>()
        let likeState = PublishRelay<(row: Int, isSelected: Bool)>()


        let input = BupDetailViewModel.Input(
            trigger: Observable.merge(viewDidLoad, pull),
            rowOfLikebutton: rowOfLikebutton,
            didTapLikeButtonOfId: didTapLikeButtonOfId,
            likeState: likeState
        )
        let output = viewModel.transform(input: input)

        output.items
            .drive(mainView.tableView.rx.items) { tv, row, item in
                switch item {
                case .detail(let item):
                    guard let cell = tv.dequeueReusableCell(
                        withIdentifier: BupDetailCell.identifier
                    ) as? BupDetailCell else {return UITableViewCell()}

                    cell.configure(item: item, likeState: viewModel.likeState[row])

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

                case .comment(let item):
                    guard let cell = tv.dequeueReusableCell(
                        withIdentifier: BupDetailCommentCell.identifier
                    ) as? BupDetailCommentCell else {return UITableViewCell()}

                    cell.configure(item)

                    return cell
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

}

private extension Reactive where Base: BupDetailViewController {

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
