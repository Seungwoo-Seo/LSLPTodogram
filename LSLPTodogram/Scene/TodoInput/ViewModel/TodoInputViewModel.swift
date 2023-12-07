//
//  TodoInputViewModel.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/11/30.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

final class TodoInputViewModel: ViewModelType {
    private let disposeBag = DisposeBag()

    private var items: [TodoInputItemIdentifiable] = [
        .todoInfo(TodoInfoInput(profileImage: UIImage(systemName: "person")!, nickname: "하하", title: "각오, 결의, 목표 등...", todoList: [])),
        .todo(TodoInput(text: "")),
        .todoAdd(Void())
    ]
    private lazy var todoList: BehaviorRelay<[TodoInputItemIdentifiable]> = BehaviorRelay(value: items)
    private var todoInputSection = TodoInputSection()

    struct Input {
        let titleChanged: PublishRelay<(title: String, row: Int)>
        let todoAddButtonTapped: PublishRelay<Void>
        let itemDeleted: ControlEvent<IndexPath>
        let postingButtonTapped: ControlEvent<Void>
    }

    struct Output {
        let sections: Observable<[TodoInputSection]>
    }

    func transform(input: Input) -> Output {
        input.titleChanged
            .bind(with: self) { owner, titleInfo in
                switch owner.items[titleInfo.row] {
                case .todoInfo(let todoInfo):
                    todoInfo.title = titleInfo.title

                case .todo(let todo):
                    todo.title = titleInfo.title

                default:
                    print("❌ 여긴 나오면 안됌")
                }
            }
            .disposed(by: disposeBag)

        input.todoAddButtonTapped
            .filter { [weak self] in
                guard let owner = self else {return false}
                return owner.items.count <= 7
            }
            .map { _ -> TodoInputItemIdentifiable in
                let todoInput = TodoInput(text: "")
                return TodoInputItemIdentifiable.todo(todoInput)
            }
            .bind(with: self) { owner, item in
                let lastIndex = owner.items.count - 1
                print(lastIndex)
                owner.items.insert(item, at: lastIndex)
                owner.todoList.accept(owner.items)
            }
            .disposed(by: disposeBag)

        input.itemDeleted
            .bind(with: self) { owner, indexPath in
                owner.items.remove(at: indexPath.row)
                owner.todoList.accept(owner.items)
            }
            .disposed(by: disposeBag)

        let sections = todoList
            .withUnretained(self)
            .map { (owner, todoList) in
                owner.todoInputSection.items = todoList
                return [owner.todoInputSection]
            }

        input.postingButtonTapped
            .withLatestFrom(todoList)
            .bind(with: self) { owner, items in

                var title: String = ""
                let product_id: String = "PersonalTodo"
                var contents: [String: String] = [:]

                for (index, item) in items.enumerated() {
                    switch item {
                    case .todoInfo(let todoInfoInput):
                        title = todoInfoInput.title

                    case .todo(let todoInput):
                        if index == 1 {
                            contents.updateValue(todoInput.title, forKey: "content")
                        } else {
                            contents.updateValue(todoInput.title, forKey: "content\(index-1)")
                        }

                    case .todoAdd:
                        continue
                    }
                }

                let request = PostCreateRequest(
                    title: title,
                    content: contents["content"] ?? "데이터 손실됨.",
                    file: nil,
                    product_id: product_id,
                    content1: contents["content1"],
                    content2: contents["content2"],
                    content3: contents["content3"],
                    content4: contents["content4"],
                    content5: contents["content5"]
                )

                print(request)

                if let token = KeychainManager.read(key: KeychainKey.token.rawValue) {
//                    NetworkManager.shared.requestTest(type: PostCreationResponse.self, api: PostRouter.create(token: token, body: request))
                } else {

                }
            }
            .disposed(by: disposeBag)

        return Output(sections: sections)
    }

    deinit {
        print("너가 찍히진 않겠찌?")
    }

}
