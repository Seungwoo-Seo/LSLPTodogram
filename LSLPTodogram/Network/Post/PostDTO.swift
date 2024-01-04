//
//  PostDTO.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/06.
//

import Foundation

struct PostDTO: Decodable {
    let image, hashTags: [String]?
    let _id: String
    let creator: CreatorDTO
    let time: String
    let title, content: String
    let content1, content2, content3, content4, content5: String?
    let productID: String
    let likes: [String]?
    let comments: [CommentDTO]?

    enum CodingKeys: String, CodingKey {
        case likes, image, hashTags, comments
        case _id
        case creator, time, title, content, content1, content2, content3, content4, content5
        case productID = "product_id"
    }

    var toBup: Bup {
        return Bup(
            id: _id,
            creator: creator.toDomain,
            title: title,
            content0: content,
            content1: content1,
            content2: content2,
            image: image,
            hashTags: hashTags,
            likes: likes,
            comments: comments?.compactMap { $0.toDomain }
        )
    }

}
