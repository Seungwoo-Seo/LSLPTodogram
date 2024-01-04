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

    func requestForUser<T: Decodable>(type: T.Type, api: URLRequestConvertible) -> Single<T> {
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

    // MARK: - 공용
    func request<T: Decodable, E: NetworkAPIError>(type: T.Type, api: URLRequestConvertible, error: E.Type) -> Single<T> {
        return Single<T>.create { observer in
            let authenticator = SesacAuthenticator()
            let credential = SesacAuthenticationCredential(
                accessToken: KeychainManager.read(key: KeychainKey.token.rawValue) ?? "",
                refreshToken: KeychainManager.read(key: KeychainKey.refresh.rawValue) ?? ""
            )
            let interceptor = AuthenticationInterceptor(
                authenticator: authenticator,
                credential: credential
            )

            AF
                .request(api, interceptor: interceptor)
                .validate(statusCode: 200...299)
                .responseDecodable(of: type) { response in
                    switch response.result {
                    case .success(let success):
                        observer(.success(success))

                    case .failure(let error):
                        switch error {
                        case .sessionTaskFailed(let sessionError):
                            if let urlError = sessionError as? URLError,
                               urlError.code == .notConnectedToInternet {
                                observer(.failure(NetworkError.internetDisconnect))
                            } else {
                                observer(.failure(NetworkError.unknown))
                            }

                        case .requestRetryFailed(let retryError, _):
                            guard let statusCode = retryError.asAFError?.responseCode else {
                                observer(.failure(NetworkError.internetDisconnect))
                                return
                            }

                            if let commonError = NetworkError.CommonError(rawValue: statusCode) {
                                observer(.failure(NetworkError.common(commonError)))

                            } else if let refreshError = NetworkError.RefreshError(rawValue: statusCode) {
                                observer(.failure(NetworkError.refresh(refreshError)))

                            } else {
                                observer(.failure(NetworkError.unknownStatusCode(statusCode)))
                            }

                        case .responseValidationFailed(reason: .unacceptableStatusCode(let statusCode)):
                            if let commonError = NetworkError.CommonError(rawValue: statusCode) {
                                observer(.failure(NetworkError.common(commonError)))

                            } else if let apiError = E(statusCode: statusCode) {
                                observer(.failure(NetworkError.api(apiError)))

                            } else {
                                observer(.failure(NetworkError.unknownStatusCode(statusCode)))
                            }

                        default:
                            observer(.failure(NetworkError.unknown))
                        }
                    }
                }

            return Disposables.create()
        }
    }

    func request<T: Decodable>(type: T.Type, api: URLRequestConvertible) -> Single<T> {
        return Single<T>.create { observer in
//            let authenticator = TestAuthenticator()
//            let credential = MyAuthenticationCredential(
//                accessToken: KeychainManager.read(key: KeychainKey.token.rawValue) ?? "",
//                refreshToken: KeychainManager.read(key: KeychainKey.refresh.rawValue) ?? ""
//            )
//            let interceptor = AuthenticationInterceptor(
//                authenticator: authenticator,
//                credential: credential
//            )

            AF
                .request(api, interceptor: MyInterceptor())
                .validate()
                .responseDecodable(of: type) { response in
                    switch response.result {
                    case .success(let success):
                        observer(.success(success))

                    case .failure(let error):
                        switch error {
                        case .requestRetryFailed(let retryError, _):
                            // 공통 에러 처리도 필요
                            print("🐶", retryError)
                            error.responseCode

                            

                        case .responseValidationFailed(reason: .unacceptableStatusCode(let code)):
                            // 공통 에러 처리도 필요
                            print("🙇🏻‍♂️", code)
                        default:
                            print("")
                        }
                        observer(.failure(error))
                    }
                }

            return Disposables.create()
        }
    }

    func upload<T: Decodable>(type: T.Type, api: MultipartFormConvertible) -> Single<T> {
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
