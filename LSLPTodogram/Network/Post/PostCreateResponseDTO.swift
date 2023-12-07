//
//  PostCreateResponseDTO.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/04.
//

import Foundation

struct PostCreateResponseDTO: Decodable {
//    "likes": [],
//    "image": [],
//    "hashTags": [],
//    "comments": [],
    let _id: String
    let creator: Creator
    let time: String
    let title: String
    let content: String
    let product_id: String

}
