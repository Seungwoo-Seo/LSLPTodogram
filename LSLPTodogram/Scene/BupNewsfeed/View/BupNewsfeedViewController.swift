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

    init(_ viewModel: BupNewsfeedViewModel) {
        super.init(nibName: nil, bundle: nil)

        let rowOfLikebutton = PublishRelay<Int>()
        let itemOfProfileImageButton = PublishRelay<Bup>()

        let input = BupNewsfeedViewModel.Input(
//            pullToRefresh: mainView.refresh.rx.controlEvent(.valueChanged).asObservable(),
            prefetchRows: mainView.tableView.rx.prefetchRows,
            itemOfProfileImageButton: itemOfProfileImageButton,
            rowOfLikebutton: rowOfLikebutton
        )
        let output = viewModel.transform(input: input)

        output.items
            .bind(to: mainView.tableView.rx.items) { tv, row, item in
                guard let cell = tv.dequeueReusableCell(
                    withIdentifier: BupCell.identifier
                ) as? BupCell else {return UITableViewCell()}

                cell.configure(item)

//                cell.bupView.infoView.profileImageButton.rx.tap
//                    .withLatestFrom(Observable.just(item))
//                    .bind(to: itemOfProfileImageButton)
//                    .disposed(by: cell.disposeBag)

                cell.bupView.infoView.profileImageButton.rx.tap
                    .withLatestFrom(Observable.just(item.creator.id))
                    .debug()
                    .bind(with: self) { owner, id in
                        let vm = OthersProfileViewModel(id: id)
                        let vc = OthersProfileViewController(vm)
                        owner.navigationController?.pushViewController(vc, animated: true)
                    }
                    .disposed(by: cell.disposeBag)

                cell.bupView.communicationView.likeButton.rx.tap
                    .withLatestFrom(Observable.just(row))
                    .bind(to: rowOfLikebutton)
                    .disposed(by: cell.disposeBag)

                cell.bupView.communicationView.commentButton.rx.tap
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

        output.likeStatus
            .bind(to: mainView.tableView.rx.likeButtonUpdate)
            .disposed(by: disposeBag)

        output.isRefreshing
            .debug()
            .bind(to: mainView.refresh.rx.isRefreshing)
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
