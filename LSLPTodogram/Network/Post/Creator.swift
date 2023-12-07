//
//  Creator.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/07.
//

import Foundation

struct Creator: Codable {
    let id: String
    let nick: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case nick
    }
}
