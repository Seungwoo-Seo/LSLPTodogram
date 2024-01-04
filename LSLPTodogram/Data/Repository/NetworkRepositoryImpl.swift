//
//  NetworkRepositoryImpl.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2024/01/03.
//

import Foundation
import RxSwift

class NetworkRepositoryImpl: NetworkRepository {
    private let networkService: NetworkManager

    init(networkService: NetworkManager) {
        self.networkService = networkService
    }

    func fetchData<T: Decodable, E: NetworkAPIError>(
        type: T.Type, api: MultipartFormConvertible, error: E.Type
    ) -> Single<T> {
        return networkService.request(type: type, api: api, error: error)
    }

}
