//
//  PostReadRequest.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/06.
//

import Foundation

struct PostReadRequest: Parameters {
    let next: String?
    let limit: Int
    let product_id: String

    init(next: String?, limit: Int = 5, product_id: String) {
        self.next = next
        self.limit = limit
        self.product_id = product_id
    }

    func asDictionary() -> [String: String] {
        if let next = next {
            return [
                "next": next,
                "limit": "\(limit)",
                "product_id": product_id
            ]
        } else {
            return [
                "limit": "\(limit)",
                "product_id": product_id
            ]
        }
    }

}
