//
//  SesacAuthenticator.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2024/01/03.
//

import Foundation
import Alamofire
import RxSwift

final class SesacAuthenticator: Authenticator {
    typealias Credential = SesacAuthenticationCredential

    private let disposeBag = DisposeBag()

    func apply(
        _ credential: SesacAuthenticationCredential,
        to urlRequest: inout URLRequest
    ) {
        urlRequest.headers.add(.authorization(credential.accessToken))
        urlRequest.headers.add(name: "SesacKey", value: NetworkBase.key)
    }

    func refresh(
        _ credential: SesacAuthenticationCredential,
        for session: Alamofire.Session,
        completion: @escaping (Result<SesacAuthenticationCredential, Error>) -> Void
    ) {
        NetworkManager.shared.requestForUser(
            type: RefreshResponse.self,
            api: Router.refresh(refreshToken: credential.refreshToken)
        )
        .subscribe { response in
            let credential = SesacAuthenticationCredential(
                accessToken: response.token,
                refreshToken: credential.refreshToken
            )
            completion(.success(credential))

        } onFailure: { error in
            completion(.failure(error))
        }
        .disposed(by: disposeBag)
    }

    func didRequest(
        _ urlRequest: URLRequest,
        with response: HTTPURLResponse,
        failDueToAuthenticationError error: Error
    ) -> Bool {
        return response.statusCode == 419
    }

    func isRequest(
        _ urlRequest: URLRequest,
        authenticatedWith credential: SesacAuthenticationCredential
    ) -> Bool {
        let accessToken = HTTPHeader.authorization(credential.accessToken).value
        return urlRequest.headers["Authorization"] == accessToken
    }
}
