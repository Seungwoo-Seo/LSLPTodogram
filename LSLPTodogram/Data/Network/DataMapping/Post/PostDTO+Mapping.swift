//
//  PostDTO+Mapping.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/06.
//

import Foundation

struct PostDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case likes, image, hashTags, comments
        case _id
        case creator, time, content
        case width = "content1"
        case height = "content2"
        case productID = "product_id"
    }
    let image, hashTags: [String]?
    let _id: String
    let creator: CreatorDTO
    let time: String
    let content: String?
    let width, height: String?
    let productID: String
    let likes: [String]?
    let comments: [CommentDTO]?
}

// MARK: - Mappings To Domain

extension PostDTO {

    func toBup(hostID: String) -> Bup {
        return Bup(
            id: _id,
            creator: creator.toDomain(),
            content: content,
            time: time,
            width: stringToCGFloat(width),
            height: stringToCGFloat(height),
            image: image,
            hashTags: hashTags,
            likes: likes,
            comments: comments?.compactMap { $0.toDomain() },
            hostID: hostID
        )
    }

}

// MARK: - Private

private func stringToCGFloat(_ string: String?) -> CGFloat? {
    if let string = string {
        let float = Float(string) ?? 0.0
        return CGFloat(float)
    } else {
        return nil
    }
}
