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
    let items: BehaviorRelay<[Bup]> = BehaviorRelay(value: [])
    private var nextCursor: String?

    struct Input {
        let prefetchRows: ControlEvent<[IndexPath]>
        let commentInBup: PublishRelay<Bup>
    }

    struct Output {
        let bupList: BehaviorRelay<[Bup]>
        let presentCommentViewController: PublishRelay<CommentViewModel>
    }

    func transform(input: Input) -> Output {
        let token = BehaviorRelay(value: KeychainManager.read(key: KeychainKey.token.rawValue) ?? "")
        let parameters = BehaviorRelay(value: PostReadRequest(next: nil, limit: 3, product_id: "PersonalTodo"))

        let presentCommentViewController = PublishRelay<CommentViewModel>()

        Observable
            .combineLatest(token, parameters)
            .flatMapLatest { (token, paramters) in
                return NetworkManager.shared.request(
                    type: PostReadResponseDTO.self,
                    api: PostRouter.read(token: token, parameters: paramters)
                )
                .catch { error in
                    print(error.localizedDescription)
                    return Single.never()
                }
            }
            .map { $0.toDomain }
            .bind(with: self) { owner, bupList in
                owner.baseItems += bupList
                owner.items.accept(owner.baseItems)
            }
            .disposed(by: disposeBag)

        input.prefetchRows
            .bind(with: self) { owner, indexPaths in
                for indexPath in indexPaths {
                    if indexPath.row == owner.items.value.count - 1 {
                        let nextCursor = owner.items.value[indexPath.row].nextCursor

                        if nextCursor != "0" {
                            parameters.accept(PostReadRequest(next: nextCursor, limit: 1, product_id: "PersonalTodo"))
                        }
                    }
                }
            }
            .disposed(by: disposeBag)

        input.commentInBup
            .debug()
            .bind(with: self) { owner, bup in
                let viewModel = CommentViewModel(bup: bup)
                presentCommentViewController.accept(viewModel)
            }
            .disposed(by: disposeBag)

        return Output(
            bupList: items,
            presentCommentViewController: presentCommentViewController
        )
    }

}
