//
//  BupContentInput.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/03.
//

import Foundation

class BupContentInput: Hashable, Identifiable {
    var content: String
    let id = UUID()

    init(text: String) {
        self.content = text
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: BupContentInput, rhs: BupContentInput) -> Bool {
        if lhs.id == rhs.id {
            return true
        } else {
            return false
        }
    }

}
