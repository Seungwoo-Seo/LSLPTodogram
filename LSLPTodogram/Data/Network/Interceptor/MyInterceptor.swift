//
//  MyInterceptor.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2024/01/01.
//

import Foundation
import Alamofire

final class MyInterceptor: RequestInterceptor {

    func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, Error>) -> Void
    ) {
        guard let accessToken = KeychainManager.read(key: KeychainKey.token.rawValue) else {
            completion(.success(urlRequest))
            return
        }

        var urlRequest = urlRequest
        urlRequest.setValue(accessToken, forHTTPHeaderField: "Authorization")
        urlRequest.setValue(NetworkBase.key, forHTTPHeaderField: "SesacKey")
        completion(.success(urlRequest))
    }

    func retry(
        _ request: Request,
        for session: Session,
        dueTo error: Error,
        completion: @escaping (RetryResult) -> Void
    ) {
        guard let response = request.task?.response as? HTTPURLResponse,
              response.statusCode == 419 else {
            completion(.doNotRetryWithError(error))
            return
        }


        print("몇 번 찍힐까요?")
        let refreshToken = KeychainManager.read(key: KeychainKey.refresh.rawValue) ?? ""
        AF
            .request(Router.refresh(refreshToken: refreshToken))
            .validate()
            .responseDecodable(of: RefreshResponse.self) { response in
                switch response.result {
                case .success(let success):
                    KeychainManager.create(
                        key: KeychainKey.token.rawValue,
                        token: success.token
                    )
                    completion(.retry)
                case .failure(let error):
                    completion(.doNotRetryWithError(error))
                }
            }
    }
}
