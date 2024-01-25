//
//  FollowerDTO+Mapping.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2024/01/09.
//

import Foundation

struct FollowerDTO: Decodable {
    let _id: String     // 이건 없으면 대체가 안됌
    let nick: String?
    let profile: String?
}

// MARK: - Mappings to Domain

extension FollowerDTO {
    func toDomain() -> Follower {
        return Follower(
            id: _id,
            nick: nick ?? "팔로워 이름 알수없음",
            profileImageString: profile
        )
    }
}
