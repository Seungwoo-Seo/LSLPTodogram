//
//  OthersProfileReadResponseDTO+Mapping.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2024/01/08.
//

import Foundation

struct OthersProfileReadResponseDTO: Decodable {
    let posts: [String]?
    let followers: [FollowersDTO]?
    let following: [FollowingDTO]?
    let _id: String
    let nick: String
    let profile: String?
}

// MARK: - Mappings to Domain

extension OthersProfileReadResponseDTO {
    func toDomain() -> OthersProfile {
        let hostID = KeychainManager.read(key: KeychainKey.id.rawValue)!

        return OthersProfile(
            id: _id,
            nick: nick,
            profileImageString: profile,
            followers: followers.map { $0.map {$0.toDomain} },
            following: following.map { $0.map {$0.toDomain} },
            hostID: hostID
        )
    }
}
