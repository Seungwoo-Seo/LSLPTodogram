//
//  LikeUpdateResponseDTO+Mapping.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/17.
//

import Foundation

struct LikeUpdateResponseDTO: Decodable {
    let like_status: Bool?
}

// MARK: - Mappings to Domain

extension LikeUpdateResponseDTO {
    func toDomain() -> Like {
        return Like(
            status: like_status ?? false
        )
    }
}
