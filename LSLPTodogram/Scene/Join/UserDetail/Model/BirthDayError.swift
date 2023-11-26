//
//  BirthDayError.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/11/26.
//

import Foundation

enum BirthDayError: Error {
    case empty // 에러로 처리하지만 birthDay는 옵셔널이기 때문에 birthDay이 없어도 에러는 아님.
    case invalid // 정규식 통과 실패

    var description: String {
        switch self {
        case .empty: return ""
        case .invalid: return "'yyyy년 MM월 dd일' 형식을 맞춰주세요."
        }
    }
}
