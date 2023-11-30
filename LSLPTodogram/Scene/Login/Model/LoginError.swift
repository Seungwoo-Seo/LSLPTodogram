//
//  LoginError.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/11/22.
//

import Foundation

enum LoginError: Int, Error {
    case 필수_값_없음 = 400
    case 계정_불일치 = 401
    case 서버_에러 = 500

    var description: String {
        switch self {
        case .필수_값_없음:
            return "이메일 혹은 비밀번호를 작성해주세요."
        case .계정_불일치:
            return "미가입한 계정이거나 비밀번호를 잘못 입력하셨습니다."
        case .서버_에러:
            return "서버 에러"
        }
    }
}
