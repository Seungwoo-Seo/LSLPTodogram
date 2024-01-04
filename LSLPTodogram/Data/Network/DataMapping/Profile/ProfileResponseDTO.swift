//
//  ProfileResponseDTO.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/10.
//

import Foundation

struct OthersProfile: Hashable {
    let id: String
    let nick: String
    let profileImageString: String?
    let followers: [Followers]?
    let following: [Following]?
    var myId: String?
}

struct OthersProfileResponseDTO: Decodable {
    let posts: [String]?
    let followers: [FollowersDTO]?
    let following: [FollowingDTO]?
    let _id: String
    let nick: String
    let profile: String?

    func toDomain(myId: String?) -> OthersProfile {
        return OthersProfile(
            id: _id,
            nick: nick,
            profileImageString: profile,
            followers: followers.map { $0.map {$0.toDomain} },
            following: following.map { $0.map {$0.toDomain} },
            myId: myId
        )
    }

    var toDomain: OthersProfile {
        return OthersProfile(
            id: _id,
            nick: nick,
            profileImageString: profile,
            followers: followers.map { $0.map {$0.toDomain} },
            following: following.map { $0.map {$0.toDomain} }
        )
    }
}

struct ProfileResponseDTO: Decodable {
    let id: String
    let nick: String
    let email: String
    let posts: [String]
    let followers: [FollowersDTO]?
    let following: [FollowingDTO]?
    let profileImageString: String?
    let phoneNum: String?
    let birthDay: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case nick, email, posts, followers, following
        case profileImageString = "profile"
        case phoneNum, birthDay
    }

    var toDomain: Profile {
        return Profile(
            _id: id,
            nick: nick,
            email: email,
            posts: posts,
            followers: followers.map { $0.map {$0.toDomain} },
            following: following.map { $0.map {$0.toDomain} },
            profileImageString: profileImageString,
            phoneNum: phoneNum,
            birthDay: birthDay
        )
    }

}
