//
//  LikeReadRequest.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/17.
//

import Foundation

struct LikeReadRequest: Parameters {
    let next: String?
    let limit: Int

    init(next: String?, limit: Int = 5) {
        self.next = next
        self.limit = limit
    }

    func asDictionary() -> [String : String] {
        if let next = next {
            return [
                "next": next,
                "limit": "\(limit)"
            ]
        } else {
            return [
                "limit": "\(limit)"
            ]
        }
    }
}
