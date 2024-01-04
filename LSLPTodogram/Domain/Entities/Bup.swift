//
//  Bup.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/11.
//

import Foundation

struct Bup: Hashable {
    let id: String
    let creator: Creator
    let title: String
    let content0: String
    let content1: String?
    let content2: String?
    let image, hashTags: [String]?
    let likes: [String]?
    let comments: [Comment]?
}
