//
//  JoinError.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/07.
//

import Foundation

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
