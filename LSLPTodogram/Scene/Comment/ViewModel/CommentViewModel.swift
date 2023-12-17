//
//  CommentViewModel.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/14.
//

import Foundation
import UIKit.UIColor
import RxCocoa
import RxSwift

final class CommentViewModel: ViewModelType {
    private let disposeBag = DisposeBag()

    let commentTableViewModel = CommentTableViewModel()

    private var baseItems: [CommentItemIdentifiable] = []

    private let bup: Observable<Bup>


    struct Input {
        let cancelBarButtomItemTapped: ControlEvent<Void>
        let postingBarButtonItemTapped: ControlEvent<Void>
    }

    struct Output {
        let commentState: Observable<Bool>
        let cancelState: Observable<Bool>
        let postingState: PublishRelay<Result<Void, Error>>
    }

    init(bup: Bup) {
        self.bup = Observable.just(bup)
        self.baseItems.append(CommentItemIdentifiable.bup(bup))
        let token = BehaviorRelay(value: KeychainManager.read(key: KeychainKey.token.rawValue) ?? "")

        token
            .flatMapLatest {
                return NetworkManager.shared.request(
                    type: ProfileResponseDTO.self,
                    api: ProfileRouter.read(token: $0)
                )
                .catch { error in
                    print("❌", error.localizedDescription)
                    return Single.never()
                }
            }
            .map { $0.toDomain }
            .withUnretained(self)
            .map { CommentItemIdentifiable.comment($1) }
            .bind(with: self) { owner, item in
                owner.baseItems.append(item)
                owner.commentTableViewModel.baseItems.onNext(owner.baseItems)
            }
            .disposed(by: disposeBag)
    }

    func transform(input: Input) -> Output {
        let postingState = PublishRelay<Result<Void, Error>>()

        let token = BehaviorRelay(value: KeychainManager.read(key: KeychainKey.token.rawValue) ?? "")

        let commentState = commentTableViewModel.commet
            .map { !$0.isEmpty }

        let cancelState = input.cancelBarButtomItemTapped
            .withLatestFrom(commentState)

        let commentRequest = Observable
            .combineLatest(token, bup, commentTableViewModel.commet)

        input.postingBarButtonItemTapped
            .withLatestFrom(commentRequest)
            .flatMapLatest {
                return NetworkManager.shared.request(
                    type: CommentDTO.self,
                    api: CommentRouter.create(token: $0.0, id: $0.1.id, content: $0.2)
                )
                .catch { error in
                    print("❌", error.localizedDescription)
                    return Single.never()
                }
            }
            .bind(with: self) { owner, respose in
                print(respose)
                postingState.accept(.success(Void()))
            }
            .disposed(by: disposeBag)

        return Output(
            commentState: commentState,
            cancelState: cancelState,
            postingState: postingState
        )
    }

}
