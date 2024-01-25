//
//  FollowingDTO+Mapping.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2024/01/09.
//

import Foundation

struct FollowingDTO: Decodable {
    let _id: String
    let nick: String?
    let profile: String?
}

// MARK: - Mappings to Domain

extension FollowingDTO {
    func toDomain() -> Following {
        return Following(
            id: _id,
            nick: nick ?? "팔로잉 이름 알수없음",
            profileImageString: profile
        )
    }
}
