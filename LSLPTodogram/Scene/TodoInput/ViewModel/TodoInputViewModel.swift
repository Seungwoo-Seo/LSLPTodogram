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

    private var todoInputSectionList: [TodoInputSection] = [
        TodoInputSection(
            items: [.todoInfo(TodoInfo(profileImage: UIImage(systemName: "person")!, nickname: "하하", title: ""))]
        ),
        TodoInputSection(items: [.todoAdd(Void())])
    ]

    struct Input {
        let todoAddButtonTapped: PublishRelay<Void>
        let itemDeleted: ControlEvent<IndexPath>
    }

    struct Output {
        let todoInputSectionList: BehaviorRelay<[TodoInputSection]>
    }

    func transform(input: Input) -> Output {
        let todoInputSectionList = BehaviorRelay(value: todoInputSectionList)

        input.todoAddButtonTapped
            .bind(with: self) { owner, _ in
                // 배열의 마지막 요소의 인덱스
                let lastIndex = owner.todoInputSectionList.count - 1
                // 마지막 요소 바로 앞에 새로운 요소를 추가

                let todo = Todo(title: "hello")
                owner.todoInputSectionList.insert(TodoInputSection(items: [.todo(todo)]), at: lastIndex)
                todoInputSectionList.accept(owner.todoInputSectionList)
            }
            .disposed(by: disposeBag)

        input.itemDeleted
            .bind(with: self) { owner, indexPath in
                owner.todoInputSectionList.remove(at: indexPath.row)
                todoInputSectionList.accept(owner.todoInputSectionList)
            }
            .disposed(by: disposeBag)

        return Output(todoInputSectionList: todoInputSectionList)
    }

}
