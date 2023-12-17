//
//  Request.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/06.
//

import Foundation

// MARK: - Request

protocol Request {}

// MARK: - Body

protocol Body: Request {}

protocol JSONBody: Body {}

protocol MultipartFormDataBody: Body {
    func asDictionary() -> [String: Data]
}

// MARK: - Parameters

protocol Parameters: Request {
    func asDictionary() -> [String: String]
}



