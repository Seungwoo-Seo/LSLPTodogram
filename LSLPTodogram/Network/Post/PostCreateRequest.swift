//
//  PostCreateRequest.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/05.
//

import Foundation

struct PostCreateRequest: MultipartFormDataBody {
    let title: String       // 서버에선 선택이지만 내 앱에선 필수
    let content: String     // 서버에선 선택이지만 내 앱에선 필수
    let file: String?
    let product_id: String  // 서버에선 선택이지만 내 앱에선 필수
    let content1: String?
    let content2: String?
    let content3: String?
    let content4: String?
    let content5: String?

    func asDictionary() -> [String : Data] {
        var resultDic: [String: Data] = [:]

        [
            "title": title,
            "content": content,
            "file": file,
            "product_id": product_id,
            "content1": content1,
            "content2": content2,
            "content3": content3,
            "content4": content4,
            "content5": content5
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
