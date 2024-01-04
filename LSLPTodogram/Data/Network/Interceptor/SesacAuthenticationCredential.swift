//
//  SesacAuthenticationCredential.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/30.
//

import Foundation
import Alamofire

struct SesacAuthenticationCredential: AuthenticationCredential {
    let accessToken: String
    let refreshToken: String

    var requiresRefresh: Bool = false
}


