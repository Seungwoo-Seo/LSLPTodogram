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
    let items = BehaviorRelay<[Bup]>(value: [])

    private let nextCursor = BehaviorSubject(value: "0")


    struct Input {
        let prefetchRows: ControlEvent<[IndexPath]>
        let rowOfLikebutton: PublishRelay<Int>
    }

    struct Output {
        let items: BehaviorRelay<[Bup]>

        let likeStatus: PublishRelay<(row: Int, status: Bool, bup: Bup)>
    }

    func transform(input: Input) -> Output {
        let likeStatus = PublishRelay<(row: Int, status: Bool, bup: Bup)>()

        let token = BehaviorRelay(value: KeychainManager.read(key: KeychainKey.token.rawValue) ?? "")
        let parameters = BehaviorRelay(value: PostReadRequest(next: nil, limit: 3, product_id: "PersonalTodo"))

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
                owner.items.accept(owner.baseItems)
            }
            .disposed(by: disposeBag)

        input.prefetchRows
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

        // MARK: - likeButton

        // 유저가 누른거임
        let localLikeState = input.rowOfLikebutton
            .withLatestFrom(items) { $1[$0].id }
            .withLatestFrom(token) { (token: $1, id: $0) }
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
            .map { $0.toDomain.status }
            .withLatestFrom(input.rowOfLikebutton) { [unowned self] in
                return (row: $1, status: $0, bup: self.baseItems[$1])
            }
            .share()

        // 컬렉션에 저장하고
        localLikeState
            .bind(to: likeStatus)
            .disposed(by: disposeBag)


        return Output(
            items: items,
            likeStatus: likeStatus
        )
    }

}
