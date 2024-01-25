//
//  UnFollowResponse.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2024/01/08.
//

import Foundation

struct UnFollowResponse: Decodable {
    private enum CodingKeys: String, CodingKey {
        case user, following
        case status = "following_status"
    }
    let user: String
    let following: String
    let status: Bool
}
