//
//  PostReadResponse.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/05.
//

import Foundation

struct PostReadResponse: Decodable {
    let data: [PostDTO]
    let nextCursor: String

    enum CodingKeys: String, CodingKey {
        case data
        case nextCursor = "next_cursor"
    }
}
