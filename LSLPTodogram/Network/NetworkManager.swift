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

    func request<T: Decodable>(type: T.Type, api: Router) -> Single<T> {
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

}

// 예시
//NetworkManager.shared.request(
//    type: EmailValidationResponse.self,
//    api: Router.emailChek(email: "iamnexttime@sesac.com")
//)
//.subscribe { response in
//    print(response)
//} onFailure: { error in
//    let statusCode = error.asAFError?.responseCode ?? 500
//    let emailError = EmailValidationError(rawValue: statusCode) ?? .서버_에러
//    print("에러 ==>", emailError.description)
//}
//.disposed(by: disposeBag)
