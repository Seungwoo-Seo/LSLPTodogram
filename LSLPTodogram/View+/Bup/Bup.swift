//
//  Bup.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/11.
//

import Foundation

struct Bup: Hashable {
    var nextCursor: String
    let nick: String
    let title: String
    let content0: String
    let content1: String?
    let content2: String?
    let likes, image, hashTags, comments: [String]?


    init(nextCursor: String = "", nick: String, title: String, content0: String, content1: String?, content2: String?, likes: [String]?, image: [String]?, hashTags: [String]?, comments: [String]?) {
        self.nextCursor = nextCursor
        self.nick = nick
        self.title = title
        self.content0 = content0
        self.content1 = content1
        self.content2 = content2
        self.likes = likes
        self.image = image
        self.hashTags = hashTags
        self.comments = comments
    }
}
