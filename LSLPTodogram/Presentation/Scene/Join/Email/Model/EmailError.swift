//
//  EmailError.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/11/26.
//

import Foundation

enum EmailError: Int, Error {
    case empty = 0
    case invalid = 1
    case reconfirm = 2
    case noRequiredValues = 400
    case duplication = 409
    case server = 500

    var description: String {
        switch self {
        case .empty: return "이메일을 입력하세요."
        case .invalid: return "유효하지 않은 이메일입니다."
        case .reconfirm: return "다시 중복체크를 해주세요."
        case .noRequiredValues: return "이메일이 누락되었습니다."
        case .duplication: return "중복된 이메읿입니다."
        case .server: return "서버 에러"
        }
    }
}
