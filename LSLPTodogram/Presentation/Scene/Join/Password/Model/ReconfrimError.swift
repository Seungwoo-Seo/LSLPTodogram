//
//  ReconfrimError.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/11/28.
//

import Foundation

enum ReconfrimError: Int, Error {
    case never
    case empty  
    case compareNotSame

    var description: String {
        switch self {
        case .never: return ""
        case .empty: return "재확인 비밀번호를 입력해주세요."
        case .compareNotSame: return "비밀번호가 다릅니다."
        }
    }
}
