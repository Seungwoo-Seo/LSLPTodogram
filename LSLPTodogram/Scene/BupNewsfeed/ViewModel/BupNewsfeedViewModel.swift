//
//  TodoNewsfeedViewModel.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/11/28.
//

import Foundation
import RxCocoa
import RxSwift

final class BupNewsfeedViewModel: ViewModelType {
    private let disposeBag = DisposeBag()

    private var baseItems: [Bup] = []
    private let nextCursor = BehaviorSubject(value: "0")

    let bupNewsfeedTableViewModel = BupNewsfeedTableViewModel()

    struct Input {
        let prefetchRows: ControlEvent<[IndexPath]>
    }

    struct Output {
        let presentCommentViewController: PublishRelay<CommentViewModel>
    }

    func transform(input: Input) -> Output {
        let token = BehaviorRelay(value: KeychainManager.read(key: KeychainKey.token.rawValue) ?? "")
        let parameters = BehaviorRelay(value: PostReadRequest(next: nil, limit: 3, product_id: "PersonalTodo"))

        let presentCommentViewController = PublishRelay<CommentViewModel>()

        let response = Observable
            .combineLatest(token, parameters)
            .flatMapLatest { (token, paramters) in
                return NetworkManager.shared.request(
                    type: PostReadResponse.self,
                    api: PostRouter.read(token: token, parameters: paramters)
                )
                .catch { error in
                    print(error.localizedDescription)
                    return Single.never()
                }
            }
            .share()

        response
            .map { $0.nextCursor }
            .bind(to: nextCursor)
            .disposed(by: disposeBag)

        response
            .map { $0.data.map { $0.toBup } }
            .bind(with: self) { owner, bupList in
                owner.baseItems += bupList
                owner.bupNewsfeedTableViewModel.baseItems.onNext(owner.baseItems)
            }
            .disposed(by: disposeBag)

        bupNewsfeedTableViewModel.likeInBup
            .withLatestFrom(token) { (token: $1, id: $0.id) }
            .flatMapLatest {
                return NetworkManager.shared.request(
                    type: LikeUpdateResponse.self,
                    api: LikeRouter.update(token: $0.token, id: $0.id)
                )
                .catch { error in
                    print("❌", error.localizedDescription)
                    return Single.never()
                }
            }
            .map { $0.toDomain }
            .debug()
            .bind(to: bupNewsfeedTableViewModel.baseLike)
            .disposed(by: disposeBag)

        bupNewsfeedTableViewModel.commentInBup
            .bind(with: self) { owner, bup in
                let viewModel = CommentViewModel(bup: bup)
                presentCommentViewController.accept(viewModel)
            }
            .disposed(by: disposeBag)

        bupNewsfeedTableViewModel.prefetchRows
            .bind(with: self) { owner, indexPaths in
                for indexPath in indexPaths {
                    if indexPath.row == owner.baseItems.count - 1 {
                        let nextCursor = try? owner.nextCursor.value()
                        if nextCursor != "0" {
                            parameters.accept(PostReadRequest(next: nextCursor, limit: 1, product_id: "PersonalTodo"))
                        }
                    }
                }
            }
            .disposed(by: disposeBag)

        return Output(
            presentCommentViewController: presentCommentViewController
        )
    }

}
