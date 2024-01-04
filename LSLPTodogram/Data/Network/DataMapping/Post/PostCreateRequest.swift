//
//  PostCreateRequest.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/05.
//

import Foundation
import UIKit.UIImage

struct PostCreateRequest: MultipartFormDataBody {
    let content: String?
    let files: [UIImage]?
    let product_id: String
    let width: String?
    let height: String?

    // 생성자가 필요: Entitiy -> Request 바꿔
    init(
        content: String?,
        files: [UIImage]?,
        product_id: String,
        width: CGFloat?,
        height: CGFloat?
    ) {
        self.content = content
        self.files = files
        self.product_id = product_id
        self.width = width != nil ? "\(width!)" : nil
        self.height = height != nil ? "\(height!)" : nil
    }

    func imagesToData() -> [Data] {
        var results: [Data] = []

        if let files {
            results = files.compactMap { $0.jpegData(compressionQuality: 0.2) }
        }

        return results
    }

    func asDictionary() -> [String: Data] {
        var resultDic: [String: Data] = [:]

        [
            "content": content,
            "product_id": product_id,
            "content1": width,
            "content2": height
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
