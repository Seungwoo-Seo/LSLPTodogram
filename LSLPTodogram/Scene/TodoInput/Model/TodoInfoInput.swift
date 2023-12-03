//
//  TodoInfoInput.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/03.
//

import Foundation
import UIKit

class TodoInfoInput: Hashable, Identifiable {
    var profileImage: UIImage
    var nickname: String
    var title: String
    var todoList: [Todo] = []
    let id = UUID()

    init(profileImage: UIImage, nickname: String, title: String, todoList: [Todo]) {
        self.profileImage = profileImage
        self.nickname = nickname
        self.title = title
        self.todoList = todoList
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: TodoInfoInput, rhs: TodoInfoInput) -> Bool {
        if lhs.id == rhs.id {
            return true
        } else {
            return false
        }
    }
}
