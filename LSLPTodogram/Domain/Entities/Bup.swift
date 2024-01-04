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
    let content: String
    let width: CGFloat?
    let height: CGFloat?
    let image, hashTags: [String]?
    let likes: [String]?
    let comments: [Comment]?
}

struct BupPage {
    let nextCursor: String
    let bups: [Bup]
}
