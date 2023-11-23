//
//  EmailValidationError.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/11/23.
//

import Foundation

enum EmailValidationError: Int, Error {
    case 필수_값_없음 = 400 
    case 사용_불가_이메일 = 409
    case 서버_에러 = 500

    var description: String {
        switch self {
        case .필수_값_없음:
            return "이메일을 작성해주세요."
        case .사용_불가_이메일:
            return "사용이 불가능한 이메일입니다."
        case .서버_에러:
            return "서버 에러"
        }
    }
}
