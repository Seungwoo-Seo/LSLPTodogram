//
//  RouterProtocol.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/16.
//

import Foundation
import Alamofire

protocol MultipartFormConvertible: URLRequestConvertible {
    var multipartFormData: MultipartFormData {get}
}
