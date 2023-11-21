//
//  NetworkManager.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/11/21.
//

import Foundation
import Alamofire
import RxSwift

class NetworkManager {
    static let shared = NetworkManager()

    private init() {}

    // 로그인 request
    func requestLogin(url: URL, parameters: Parameters?, headers: HTTPHeaders?) -> Single<LoginResponse> {
        return Single<LoginResponse>.create { observer in
            AF
                .request(
                    url,
                    method: .post,
                    parameters: parameters,
                    encoding: JSONEncoding.default,
                    headers: headers
                )
                .validate()
                .responseDecodable(of: LoginResponse.self) { response in
                    switch response.result {
                    case .success(let success):
                        observer(.success(success))

                    case .failure:
                        let statusCode = response.response?.statusCode ?? 500
                        let error = LoginError(rawValue: statusCode) ?? .서버_에러
                        observer(.failure(error))
                    }
                }

            return Disposables.create {

            }
        }
    }

    // 이메일 중복 검증 request
    func requestEmailValidation(url: URL, parameters: Parameters?, headers: HTTPHeaders?) -> Single<EmailValidationResponse> {
        return Single<EmailValidationResponse>.create { observer in
            AF
                .request(
                    url,
                    method: .post,
                    parameters: parameters,
                    encoding: JSONEncoding.default,
                    headers: headers
                )
                .responseDecodable(of: EmailValidationResponse.self) { response in
                    switch response.result {
                    case .success(let success):
                        observer(.success(success))

                    case .failure:
                        let statusCode = response.response?.statusCode ?? 500
                        let error = EmailValidationError(rawValue: statusCode) ?? .서버_에러
                        observer(.failure(error))
                    }
                }

            return Disposables.create()
        }
    }
    func requestEmailValidation(
        endpoint url: URL,
        method: HTTPMethod,
        parameters: Parameters?,
        encoding: ParameterEncoding,
        headers: HTTPHeaders?
    ) -> Single<EmailValidationResponse> {
        return Single<EmailValidationResponse>.create { observer in
            AF
                .request(
                    url,
                    method: method,
                    parameters: parameters,
                    encoding: encoding,
                    headers: headers
                )
                .responseDecodable(of: EmailValidationResponse.self) { response in
                    switch response.result {
                    case .success(let success):
                        observer(.success(success))

                    case .failure:
                        let statusCode = response.response?.statusCode ?? 500
                        let error = JoinError(rawValue: statusCode) ?? .서버_에러
                        observer(.failure(error))
                    }
                }

            return Disposables.create()
        }
    }

    // 회원가입 request
    func requestJoin(url: URL, parameters: Parameters?, headers: HTTPHeaders?) -> Single<JoinDTO> {
        return Single<JoinDTO>.create { observer in
            AF
                .request(
                    url,
                    method: .post,
                    parameters: parameters,
                    encoding: JSONEncoding.default,
                    headers: headers
                )
                .responseDecodable(of: JoinDTO.self) { response in
                    switch response.result {
                    case .success(let success):
                        observer(.success(success))

                    case .failure:
                        let statusCode = response.response?.statusCode ?? 500
                        let error = JoinError(rawValue: statusCode) ?? .서버_에러
                        observer(.failure(error))
                    }
                }

            return Disposables.create()
        }
    }
    func requestJoin(
        endpoint url: URL,
        method: HTTPMethod,
        parameters: Parameters?,
        encoding: URLEncoding,
        headers: HTTPHeaders?
    ) -> Single<JoinDTO> {
        return Single<JoinDTO>.create { observer in
            AF
                .request(
                    url,
                    method: method,
                    parameters: parameters,
                    encoding: encoding,
                    headers: headers
                )
                .responseDecodable(of: JoinDTO.self) { response in
                    switch response.result {
                    case .success(let success):
                        observer(.success(success))

                    case .failure:
                        let statusCode = response.response?.statusCode ?? 500
                        let error = JoinError(rawValue: statusCode) ?? .서버_에러
                        observer(.failure(error))
                    }
                }

            return Disposables.create()
        }
    }

}
