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
}
