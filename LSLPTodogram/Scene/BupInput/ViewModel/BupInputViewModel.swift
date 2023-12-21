//
//  BupInputViewModel.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/11/30.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

final class BupInputViewModel: ViewModelType {
    private let disposeBag = DisposeBag()

    private var baseItems: [BupInputItemIdentifiable] = []
    private let items: BehaviorRelay<[BupInputItemIdentifiable]> = BehaviorRelay(value: [])

    struct Input {
        let title: PublishRelay<(title: String, row: Int)>
        let content: PublishRelay<(content: String, row: Int)>
        let bupAddButtonTapped: PublishRelay<Void>
        let itemDeleted: ControlEvent<IndexPath>
        let postingButtonTapped: PublishRelay<Void>
    }

    struct Output {
        let items: BehaviorRelay<[BupInputItemIdentifiable]>
        let postingDone: PublishRelay<Void>
    }

    func transform(input: Input) -> Output {
        // Base
        let token = BehaviorRelay(value: KeychainManager.read(key: KeychainKey.token.rawValue) ?? "")

        // Output
        let postingDone = PublishRelay<Void>()

        let profile = token
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

        profile
            .bind(with: self) { owner, profile in
                let bupInfoInput = BupInfoInput(
                    profileImageString: profile.profileImageString,
                    nickname: profile.nick,
                    title: "각오, 목표, 열정..."
                )

                let firstItems = [
                    BupInputItemIdentifiable.info(bupInfoInput),
                    BupInputItemIdentifiable.content(BupContentInput(text: "할 일...")),
                    BupInputItemIdentifiable.add
                ]

                owner.baseItems = firstItems
                owner.items.accept(owner.baseItems)
            }
            .disposed(by: disposeBag)

        input.title
            .bind(with: self) { owner, value in
                owner.updateItems(row: value.row, text: value.title)
            }
            .disposed(by: disposeBag)

        input.content
            .bind(with: self) { owner, value in
                owner.updateItems(row: value.row, text: value.content)
            }
            .disposed(by: disposeBag)

        input.bupAddButtonTapped
            .withUnretained(self)
            .filter { (owner, _) in
                return owner.baseItems.count <= 4
            }
            .map { (owner, _) in
                return BupInputItemIdentifiable.content(BupContentInput(text: "할 일..."))
            }
            .bind(with: self) { owner, item in
                let lastIndex = owner.baseItems.count - 1
                owner.baseItems.insert(item, at: lastIndex)
                owner.items.accept(owner.baseItems)
            }
            .disposed(by: disposeBag)

        input.itemDeleted
            .bind(with: self) { owner, indexPath in
                owner.baseItems.remove(at: indexPath.row)
                owner.items.accept(owner.baseItems)
            }
            .disposed(by: disposeBag)

        input.postingButtonTapped
            .withLatestFrom(token) { [unowned self] (_, token) in
                return (token: token, request: self.toRequest)
            }
            .flatMapLatest {
                return NetworkManager.shared.upload(
                    type: PostCreateResponse.self,
                    api: PostRouter.create(token: $0.token, body: $0.request)
                )
                .catch { error in
                    print("❌", error.localizedDescription)
                    return Single.never()
                }
            }
            .bind(with: self) { owner, _ in
                postingDone.accept(Void())
            }
            .disposed(by: disposeBag)

        return Output(
            items: items,
            postingDone: postingDone
        )
    }

}

private extension BupInputViewModel {

    func updateItems(row: Int, text: String) {
        let base = baseItems[row]
        let item = items.value[row]

        switch base {
        case .info(let info):
            info.title = text
        case .content(let content):
            content.content = text
        default: return
        }

        switch item {
        case .info(let info):
            info.title = text
        case .content(let content):
            content.content = text
        default: return
        }
    }

    var toRequest: PostCreateRequest {
        let items = self.items.value

        let title: String! = items
            .filter {
                switch $0 {
                case .info: return true
                case .content, .add: return false
                }
            }
            .map { (item) -> String in
                switch item {
                case .info(let info): return info.title
                default: return ""
                }
            }
            .first

        let contents = items
            .filter {
                switch $0 {
                case .info, .add: return false
                case .content: return true
                }
            }
            .map { (item) -> String in
                switch item {
                case .content(let content): return content.content
                default: return ""
                }
            }
            .filter { !$0.isEmpty }

        let product_id = "PersonalTodo"  // Bup

        return PostCreateRequest(
            title: title,
            content: contents[0],
            file: nil,
            product_id: product_id,
            content1: contents[1],
            content2: contents[2],
            content3: nil,
            content4: nil,
            content5: nil
        )
    }

}
