//
//  PostDTO.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/06.
//

import Foundation

struct PostDTO: Codable {
    let likes, image, hashTags, comments: [String]?
    let id: String
    let creator: Creator
    let time: String
    let title, content: String
    let content1, content2, content3, content4, content5: String?
    let productID: String

    enum CodingKeys: String, CodingKey {
        case likes, image, hashTags, comments
        case id = "_id"
        case creator, time, title, content, content1, content2, content3, content4, content5
        case productID = "product_id"
    }
}
