//
//  BupInfoInput.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/03.
//

import Foundation
import UIKit

class BupInfoInput: Hashable, Identifiable {
    let profileImageString: String?
    let nickname: String
    var title: String
    let id = UUID()

    init(profileImageString: String?, nickname: String, title: String) {
        self.profileImageString = profileImageString
        self.nickname = nickname
        self.title = title
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: BupInfoInput, rhs: BupInfoInput) -> Bool {
        if lhs.id == rhs.id {
            return true
        } else {
            return false
        }
    }
}
