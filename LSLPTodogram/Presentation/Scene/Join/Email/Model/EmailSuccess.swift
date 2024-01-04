//
//  EmailSuccess.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/11/26.
//

import Foundation

enum EmailSuccess {
    case available
    case duplicatePass(message: String)

    var description: String {
        switch self {
        case .available: return ""
        case .duplicatePass(let message):
            return message
        }
    }
}
