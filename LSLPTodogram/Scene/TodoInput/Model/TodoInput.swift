//
//  TodoInput.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/03.
//

import Foundation

class TodoInput: Hashable, Identifiable {
    var title: String
    let id = UUID()

    init(text: String) {
        self.title = text
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: TodoInput, rhs: TodoInput) -> Bool {
        if lhs.id == rhs.id {
            return true
        } else {
            return false
        }
    }

}
