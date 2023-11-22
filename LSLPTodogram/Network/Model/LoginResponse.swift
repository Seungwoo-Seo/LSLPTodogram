//
//  LoginResponse.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/11/22.
//

import Foundation

struct LoginResponse: Decodable {
    let token: String
    let refreshToken: String

    let isError: Bool

    enum CodingKeys: String, CodingKey {
        case token = "token"
        case refreshToken = "refreshToken"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.token = try container.decode(String.self, forKey: .token)
        self.refreshToken = try container.decode(String.self, forKey: .refreshToken)
        self.isError = false
    }

    init(isError: Bool) {
        self.token = ""
        self.refreshToken = ""
        self.isError = isError
    }

}
