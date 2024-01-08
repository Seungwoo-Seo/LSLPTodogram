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

        let rowOfLikebutton = PublishRelay<Int>()
        let postCreatorId = PublishRelay<String>()

        let input = BupNewsfeedViewModel.Input(
            trigger: Observable.merge(viewDidLoad, pull),
            prefetchRows: mainView.tableView.rx.prefetchRows,
            postCreatorId: postCreatorId,
            rowOfLikebutton: rowOfLikebutton
        )
        let output = viewModel.transform(input: input)

        output.items
            .bind(to: mainView.tableView.rx.items) { tv, row, item in
                guard let cell = tv.dequeueReusableCell(
                    withIdentifier: BupCell.identifier
                ) as? BupCell else {return UITableViewCell()}

                cell.configure(item: item)

                cell.imageUrls
                    .bind(to: cell.imageCollectionView.rx.items(cellIdentifier: ImageCell.identifier)) { index, string, cell in
                        guard let cell = cell as? ImageCell else {return}

                        cell.removeButton.isHidden = true
                        let token = KeychainManager.read(key: KeychainKey.token.rawValue) ?? ""
                        cell.imageView.requestModifier(with: string, token: token)
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

                cell.communicationButtonStackView.likeButton.rx.tap
                    .withLatestFrom(Observable.just(row))
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

        output.likeStatus
            .bind(to: mainView.tableView.rx.likeButtonUpdate)
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
