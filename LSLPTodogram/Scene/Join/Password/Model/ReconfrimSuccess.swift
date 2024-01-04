//
//  ReconfrimSuccess.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/11/28.
//

import Foundation

enum ReconfrimSuccess {
    case compareSame

    var description: String {
        switch self {
        case .compareSame: return "비밀번호가 같습니다."
        }
    }
}
