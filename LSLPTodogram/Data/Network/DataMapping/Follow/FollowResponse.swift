//
//  FollowResponse.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/20.
//

import Foundation

struct FollowResponse: Decodable {
    private enum CodingKeys: String, CodingKey {
        case user, following
        case status = "following_status"
    }
    let user: String
    let following: String
    let status: Bool
}

struct FollowersDTO: Decodable {
    let _id: String     // 이건 없으면 대체가 안됌
    let nick: String?
    let profile: String?

    var toDomain: Followers {
        return Followers(
            id: _id,
            nick: nick ?? "팔로워 이름 알수없음",
            profileImageString: profile
        )
    }
}

struct FollowingDTO: Decodable {
    let _id: String
    let nick: String?
    let profile: String?

    var toDomain: Following {
        return Following(
            id: _id,
            nick: nick ?? "팔로잉 이름 알수없음",
            profileImageString: profile
        )
    }
}

struct Followers: Hashable {
    let id: String
    let nick: String
    let profileImageString: String?
}

struct Following: Hashable {
    let id: String
    let nick: String
    let profileImageString: String?
}
