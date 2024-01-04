//
//  ProfileUpdateRequest.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/16.
//

import Foundation

struct ProfileUpdateRequest: MultipartFormDataBody {
    func imagesToData() -> [Data] {
        []
    }

    let nick: String?
    let phoneNum: String?
    let birthDay: String?
//    let profile: Data

    func asDictionary() -> [String : Data] {
        var resultDic: [String: Data] = [:]

        [
            "nick": nick,
            "phoneNum": phoneNum,
            "birthDay": birthDay
        ]
            .forEach {
                if let value = $0.value, !value.isEmpty {
                    if let data = value.data(using: .utf8) {
                        resultDic.updateValue(data, forKey: $0.key)
                    }
                }
            }

        return resultDic
    }

}
