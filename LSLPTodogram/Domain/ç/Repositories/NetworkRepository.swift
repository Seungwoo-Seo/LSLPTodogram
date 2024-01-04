//
//  NetworkRepository.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2024/01/03.
//

import Foundation
import RxSwift

protocol NetworkRepository {

    func fetchData<T: Decodable, E: NetworkAPIError>(
        type: T.Type, api: MultipartFormConvertible, error: E.Type
    ) -> Single<T>

}
