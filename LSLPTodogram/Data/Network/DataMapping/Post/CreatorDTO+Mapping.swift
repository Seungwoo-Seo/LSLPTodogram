//
//  CreatorDTO+Mapping.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/07.
//

import Foundation

struct CreatorDTO: Decodable {
    let _id: String?
    let nick: String?
    let profile: String?
}

// MARK: - Mappings To Domain

extension CreatorDTO {
    func toDomain() -> Creator {
        return Creator(
            id: _id ?? "id 파싱 실패",
            nick: nick ?? "닉네임 파싱 실패",
            profile: profile ?? "person"
        )
    }
}
