//
//  PasswordSuccess.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/11/28.
//

import Foundation

enum PasswordSuccess {
    case availablePassword

    var description: String {
        switch self {
        case .availablePassword: return "사용할 수 있는 비밀번호 입니다."
        }
    }
}
