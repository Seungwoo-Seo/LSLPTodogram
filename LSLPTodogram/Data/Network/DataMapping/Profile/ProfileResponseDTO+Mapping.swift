//
//  ProfileResponseDTO+Mapping.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/10.
//

import Foundation

struct ProfileResponseDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case nick, email, posts, followers, following
        case profileImageString = "profile"
        case phoneNum, birthDay
    }
    let id: String
    let nick: String
    let email: String
    let posts: [String]
    let followers: [FollowerDTO]?
    let following: [FollowingDTO]?
    let profileImageString: String?
    let phoneNum: String?
    let birthDay: String?
}

// MARK: - Mappings to Domain

extension ProfileResponseDTO {
    func toDomain() -> Profile {
        return Profile(
            _id: id,
            nick: nick,
            email: email,
            posts: posts,
            followers: followers.map { $0.map {$0.toDomain()} },
            following: following.map { $0.map {$0.toDomain()} },
            profileImageString: profileImageString,
            phoneNum: phoneNum,
            birthDay: birthDay
        )
    }
}
