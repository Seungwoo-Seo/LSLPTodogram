//
//  PostReadResponseDTO+Mapping.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/05.
//

import Foundation

struct PostReadResponseDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case data
        case nextCursor = "next_cursor"
    }
    let data: [PostDTO]
    let nextCursor: String
}

// MARK: - Mappings to Domain

extension PostReadResponseDTO {

    func toDomain() -> BupPage {
        return BupPage(
            nextCursor: nextCursor,
            bups: data.map { $0.toBup() } 
        )
    }

}
