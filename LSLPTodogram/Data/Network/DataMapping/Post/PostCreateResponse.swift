//
//  PostCreateResponse.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/04.
//

import Foundation

struct PostCreateResponse: Decodable {
//    "likes": [],
    let image: [String]?
    let hashTags: [String]?
//    "comments": [],
    let _id: String
    let creator: CreatorDTO
    let time: String
    let title: String?
    let content: String
    let product_id: String

}
