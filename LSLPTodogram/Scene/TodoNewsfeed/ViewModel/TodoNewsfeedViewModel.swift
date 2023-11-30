//
//  TodoNewsfeedViewModel.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/11/28.
//

import Foundation
import RxCocoa
import RxSwift

import UIKit

final class TodoNewsfeedViewModel: ViewModelType {
    private let disposeBag = DisposeBag()

    let todoInfoList: BehaviorRelay<[TodoInfo]> = BehaviorRelay(value: [])

    struct Input {
        
    }

    struct Output {
        let todoInfoList: BehaviorRelay<[TodoInfo]>
    }

    deinit {
        print("hihihihihihihihihihihihihihihihihihi")
        print(#function)
    }

    func transform(input: Input) -> Output {

        let mock = [
            TodoInfo(
                profileImage: UIImage(systemName: "heart")!,
                nickname: "탈무드",
                title: "오늘 메인뷰 완성",
                todoList: [
                    Todo(title: "TodoView"),
                    Todo(title: "NewsView"),
                    Todo(title: "TestView"),
                    Todo(title: "HelloView")
                ]
            ),
            TodoInfo(
                profileImage: UIImage(systemName: "heart")!,
                nickname: "탈무드",
                title: "오늘 메인뷰 완성",
                todoList: [
                    Todo(title: "TodoView"),
                    Todo(title: "NewsView"),
                    Todo(title: "TestView"),
                    Todo(title: "HelloView")
                ]
            ),
            TodoInfo(
                profileImage: UIImage(systemName: "heart")!,
                nickname: "탈무드",
                title: "오늘 메인뷰 완성",
                todoList: [
                    Todo(title: "TodoView"),
                    Todo(title: "NewsView"),
                    Todo(title: "TestView"),
                    Todo(title: "HelloView")
                ]
            )
        ]
        todoInfoList.accept(mock)




        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            guard let self else {return}
            let mock1 = [
                TodoInfo(
                    profileImage: UIImage(systemName: "heart")!,
                    nickname: "탈무드11111",
                    title: "오늘 메인뷰 완성----------",
                    todoList: [
                        Todo(title: "TodoView"),
                        Todo(title: "NewsView"),
                        Todo(title: "TestView"),
                        Todo(title: "HelloView")
                    ]
                ),
                TodoInfo(
                    profileImage: UIImage(systemName: "heart")!,
                    nickname: "탈무드11111",
                    title: "오늘 메인뷰 완성----------",
                    todoList: [
                        Todo(title: "TodoViewTodoViewTodoView"),
                        Todo(title: "NewsView"),
                        Todo(title: "TestView"),
                        Todo(title: "HelloView")
                    ]
                ),
                TodoInfo(
                    profileImage: UIImage(systemName: "heart")!,
                    nickname: "탈무드11111",
                    title: "오늘 메인뷰 완성----------",
                    todoList: [
                        Todo(title: "TodoView"),
                        Todo(title: "NewsViewNewsViewNewsViewNewsView"),
                        Todo(title: "TestView"),
                        Todo(title: "HelloViewHelloViewHelloViewHelloViewHelloView")
                    ]
                )
            ]
            self.todoInfoList.accept(mock1)
        }


        return Output(todoInfoList: todoInfoList)
    }

}
