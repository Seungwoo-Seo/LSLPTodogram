//
//  NetworkModel.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/11/21.
//

import Foundation

// 로그인
struct LoginResponse: Decodable {
    let token: String
    let refreshToken: String
}

// 이메일 중복 검증
struct EmailValidationResponse: Decodable {
    let message: String
}

// 회원가입
struct JoinDTO: Decodable {
    let _id: String
    let email: String
    let nick: String
    let phoneNum: String?
    let birthDay: String?
}

enum LoginError: Int, Error {
    case 필수_값_없음 = 400  // 이메일 누락
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

enum EmailValidationError: Int, Error {
    case 필수_값_없음 = 400  // 이메일 누락
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

enum JoinError: Int, Error {
    case 필수_값_없음 = 400
    case 이미_가입한_계정 = 409
    case 서버_에러 = 500

    var description: String {
        switch self {
        case .필수_값_없음:
            return "필수 값을 입력해주세요."
        case .이미_가입한_계정:
            return "이미 가입한 계정입니다."
        case .서버_에러:
            return "서버 에러"
        }
    }
}


