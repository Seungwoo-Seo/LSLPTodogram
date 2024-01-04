//
//  LikeUpdateResponse.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/17.
//

import Foundation

struct LikeUpdateResponse: Decodable {
    let like_status: Bool?

    var toDomain: Like {
        return Like(
            status: like_status ?? false
        )
    }
}
