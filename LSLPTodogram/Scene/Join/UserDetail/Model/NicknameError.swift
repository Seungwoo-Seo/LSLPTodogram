//
//  NicknameError.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/11/26.
//

import Foundation

enum NicknameError: Error {
    case empty  // 닉네임이 없음
    case invalid // 정규식 통과 실패

    case same

    var description: String {
        switch self {
        case .empty: return "닉네임 입력은 필수입니다."
        case .invalid: return "한글, 영어, 숫자, _만 가능하고, 2 ~ 20글자만 가능합니다."

        case .same: return "기존 닉네임과 동일합니다."

        }
    }
}
