//
//  Comment.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/15.
//

import Foundation

struct Comment: Hashable {
    let id: String
    let time: String
    let content: String
    let creator: Creator
}
