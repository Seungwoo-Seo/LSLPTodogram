//
//  NetworkManager.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/11/21.
//

import Foundation
import Alamofire
import RxSwift

final class NetworkManager {
    static let shared = NetworkManager()

    private init() {}

    // MARK: - 공용

    func request<T: Decodable>(type: T.Type, api: URLRequestConvertible) -> Single<T> {
        return Single<T>.create { observer in
            AF
                .request(api)
                .validate()
                .responseDecodable(of: type) { response in
                    switch response.result {
                    case .success(let success):
                        observer(.success(success))

                    case .failure(let error):
                        observer(.failure(error))
                    }
                }

            return Disposables.create()
        }
    }

    // MARK: - PostRouter 전용

    func upload<T: Decodable>(type: T.Type, api: PostRouter) -> Single<T> {
        return Single<T>.create { observer in
            AF
                .upload(multipartFormData: api.multipartFormData, with: api)
                .validate()
                .responseDecodable(of: type) { response in
                    switch response.result {
                    case .success(let success):
                        observer(.success(success))
                        print("success => ", success)
                        
                    case .failure(let error):
                        observer(.failure(error))
                        print(error)
                    }
                }

            return Disposables.create()
        }
    }

}
