//
//  TodoNewsfeedViewModel.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/11/28.
//

import Foundation
import RxCocoa
import RxSwift

final class BupNewsfeedViewModel: BupViewModelType {
    private let disposeBag = DisposeBag()

    private var lists: [BupContainer] = []
    let bupContainerList: BehaviorRelay<[BupContainer]> = BehaviorRelay(value: [])
    private var nextCursor: String?

    struct Input {
        let prefetchItems: ControlEvent<[IndexPath]>
    }

    struct Output {
        let bupContainerList: BehaviorRelay<[BupContainer]>
    }

    func transform(input: Input) -> Output {
        let token = BehaviorRelay(value: KeychainManager.read(key: KeychainKey.token.rawValue) ?? "")
        let parameters = BehaviorRelay(value: PostReadRequest(next: nil, limit: 3, product_id: "PersonalTodo"))

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
            .withUnretained(self)
            .map { (owner, response) in
                return owner.toDomainList(response)
            }
            .bind(with: self) { owner, bupContainerList in
                owner.lists += bupContainerList
                owner.bupContainerList.accept(owner.lists)
            }
            .disposed(by: disposeBag)

        input.prefetchItems
            .bind(with: self) { owner, indexPaths in
                for indexPath in indexPaths {
                    if indexPath.section == owner.bupContainerList.value.count - 1 {
                        let nextCursor = owner.bupContainerList.value[indexPath.section].nextCursor

                        if nextCursor != "0" {
                            parameters.accept(PostReadRequest(next: nextCursor, limit: 1, product_id: "PersonalTodo"))
                        }
                    }
                }
            }
            .disposed(by: disposeBag)



        return Output(
            bupContainerList: bupContainerList
        )
    }

}

private extension BupNewsfeedViewModel {

    func toDomainList(_ response: PostReadResponseDTO) -> [BupContainer] {
        let bupList = response.data

        return bupList.map { bup in
            // top
            let bupTop = BupTop(nick: bup.creator.nick, title: bup.title)

            // content
            let bupContents = [
                bup.content,
                bup.content1,
                bup.content2,
                bup.content3,
                bup.content4
            ].filter { $0 != nil }
                .compactMap { $0 }
                .map { BupContent(content: $0) }

            // bottom
            let bupBottom = BupBottom(
                likes: bup.likes,
                image: bup.image,
                hashTags: bup.hashTags,
                comments: bup.comments
            )

            let nextCursor = response.nextCursor

            return BupContainer(
                bupTop: bupTop,
                bupContents: bupContents,
                bupBottom: bupBottom,
                nextCursor: nextCursor
            )
        }
    }

}
