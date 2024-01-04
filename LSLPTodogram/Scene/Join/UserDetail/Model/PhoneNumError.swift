//
//  PhoneNumError.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/11/26.
//

import Foundation

enum PhoneNumError: Error {
    case empty // 에러로 처리하지만 phoneNum은 옵셔널이기 때문에 phoneNum이 없어도 에러는 아님.
    case invalid // 정규식 통과 실패

    case same

    var description: String {
        switch self {
        case .empty: return ""
        case .invalid: return "'01'로 시작하고 '-'없이 입력해야합니다."

        case .same: return "기존 핸드폰 번호와 동일합니다."
        }
    }
}
