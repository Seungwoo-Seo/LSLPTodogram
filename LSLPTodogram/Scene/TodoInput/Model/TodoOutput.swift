//
//  TodoOutput.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/04.
//

import Foundation

struct TodoOutput {
    var title: String = ""
    var content: String = ""
    var file: String = ""
    var product_id: String = ""
    var content1: String = ""
    var content2: String = ""
    var content3: String = ""
    var content4: String = ""
    var content5: String = ""

    mutating func setTodoInfoInput(_ todoInfoInput: TodoInfoInput) {
        self.title = todoInfoInput.title
    }

    mutating func setTodoInput(_ todoInput: TodoInput) {
        self.content = todoInput.title
    }

}
