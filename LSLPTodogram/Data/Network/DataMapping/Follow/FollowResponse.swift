//
//  FollowResponse.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/20.
//

import Foundation

struct FollowResponse: Decodable {
    private enum CodingKeys: String, CodingKey {
        case user, following
        case status = "following_status"
    }
    let user: String
    let following: String
    let status: Bool
}
