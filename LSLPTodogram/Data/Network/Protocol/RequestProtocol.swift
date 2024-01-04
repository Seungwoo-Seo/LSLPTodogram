//
//  Request.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/06.
//

import Foundation

// MARK: - Body

protocol Body {}

protocol JSONBody: Body {}

protocol MultipartFormDataBody: Body {
    func asDictionary() -> [String: Data]
    func imagesToData() -> [Data]
}

// MARK: - Parameters

protocol Parameters {
    func asDictionary() -> [String: String]
}



