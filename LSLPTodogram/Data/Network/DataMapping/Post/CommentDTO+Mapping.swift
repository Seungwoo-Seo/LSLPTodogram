//
//  CommentDTO+Mapping.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/17.
//

import Foundation

struct CommentDTO: Decodable {
    let _id: String?
    let time: String?
    let content: String?
    let creator: CreatorDTO
}

// MARK: - Mappings To Domain

extension CommentDTO {
    func toDomain() -> Comment {
        return Comment(
            id: _id ?? "id 파싱 실패",
            time: time ?? "time 파싱 실패",
            content: content ?? "content 파싱 실패",
            creator: creator.toDomain()
        )
    }
}


