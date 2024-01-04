//
//  FetchPostUseCase.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2024/01/03.
//

import Foundation
import RxSwift

protocol FetchPostUseCase {
    func execute(parameters: Parameters) -> Single<BupPage>
}

struct FetchBupPageUseCaseImpl: FetchPostUseCase {
    let networkRepository: NetworkRepository

    func execute(parameters: Parameters) -> Single<BupPage> {
        return networkRepository
            .fetchData(
                type: PostReadResponseDTO.self,
                api: PostRouter.read(parameters: parameters),
                error: NetworkError.PostReadError.self
            )
            .map { $0.toDomain() }
    }

}
