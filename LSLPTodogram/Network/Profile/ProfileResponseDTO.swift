//
//  ProfileResponseDTO.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/10.
//

import Foundation

struct ProfileResponseDTO: Decodable {
    let id: String
    let nick: String
    let email: String
    let posts: [String]
    let followers: [String]
    let following: [String]

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case nick, email, posts, followers, following
    }
}
