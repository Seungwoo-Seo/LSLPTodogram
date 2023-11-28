//
//  PasswordError.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/11/28.
//

import Foundation

enum PasswordError: Int, Error {
    case never
    case empty
    case invalid

    var description: String {
        switch self {
        case .never: return ""
        case .empty: return "비밀번호를 입력하세요."
        case .invalid: return "비밀번호 형식이 맞지 않습니다."
        }
    }
}
