//
//  JoinDTO.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/07.
//

import Foundation

struct JoinDTO: Decodable {
    let _id: String
    let email: String
    let nick: String
    let phoneNum: String?
    let birthDay: String?
}
