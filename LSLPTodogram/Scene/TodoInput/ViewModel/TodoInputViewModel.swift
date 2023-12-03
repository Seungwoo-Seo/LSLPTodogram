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

        return Output(sections: sections)
    }

}
