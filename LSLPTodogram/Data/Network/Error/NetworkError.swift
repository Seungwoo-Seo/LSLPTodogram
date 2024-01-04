//
//  NetworkError.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/30.
//

import Foundation

protocol NetworkErrorProtocol: Error {
    associatedtype CommonError: NetworkAPIError
    associatedtype RefreshError: NetworkAPIError
    associatedtype PostCreateError: NetworkAPIError
    associatedtype PostReadError: NetworkAPIError

    var description: String {get}
}

protocol NetworkAPIError: Error {
    init?(statusCode: Int)
    var description: String {get}
}

enum NetworkError: NetworkErrorProtocol {
    case common(CommonError)
    case refresh(RefreshError)
    case api(NetworkAPIError)
    case unknownStatusCode(Int)
    case internetDisconnect
    case unknown

    var description: String {
        switch self {
        case .common(let error):
            return error.description
        case .refresh(let error):
            return error.description
        case .api(let error):
            return error.description
        case .unknownStatusCode(let statusCode):
            return "협의되지 않은 상태코드 \(statusCode)"
        case .internetDisconnect:
            return "네트워크 연결이 없습니다."
        case .unknown:
            return "핸들링하지 않은 에러"
        }
    }

    /// 공통 에러
    enum CommonError: Int, NetworkAPIError {
        case invalidSesacKey = 420      // SesacKey가 없거나 틀림
        case plethoraRequest = 429      // 과호출
        case invalidURL = 444           // 비정상 URL을 통해 요청
        case server = 500               // 서버 에러

        init?(statusCode: Int) {
            if let error = Self.init(rawValue: statusCode) {
                self = error
            } else {
                return nil
            }
        }

        var description: String {
            switch self {
            case .invalidSesacKey: return "SesacKey가 없거나 틀립니다."
            case .plethoraRequest: return "과호출"
            case .invalidURL: return "비정상 URL을 통해 요청"
            case .server: return "서버 에러"
            }
        }
    }

    /// 리프레쉬 에러
    enum RefreshError: Int, NetworkAPIError {
        case invalidAccessToken = 401       // 유효하지 않은 액세스 토큰
        case forbidden = 403                // 접근 권한이 없음
        case yetAccessTokenExpiration = 409 // 액세스 토큰이 아직 만료되지 않음
        case refreshTokenExpiration = 418   // 리프레시 토큰이 만료됨

        init?(statusCode: Int) {
            if let error = Self.init(rawValue: statusCode) {
                self = error
            } else {
                return nil
            }
        }

        var description: String {
            switch self {
            case .invalidAccessToken: return "유효하지 않은 액세스 토큰"
            case .forbidden: return "접근 권한이 없음"
            case .yetAccessTokenExpiration: return "액세스 토큰이 아직 만료되지 않음"
            case .refreshTokenExpiration: return "리프레시 토큰이 만료됨"
            }
        }
    }

    /// 포스트 작성 에러
    enum PostCreateError: Int, NetworkAPIError {
        case invalidRequest = 400           // 파일의 제한 사항과 맞지 않다.
        case invalidAccessToken = 401       // 유효하지 않은 액세스 토큰
        case forbidden = 403                // 접근 권한이 없음
        case dbServerObstacle = 410         // DB 서버 장애로 게시글이 저장되 않음
        case accessTokenExpiration = 419    // 액세스 토큰 만료

        init?(statusCode: Int) {
            if let error = Self.init(rawValue: statusCode) {
                self = error
            } else {
                return nil
            }
        }

        var description: String {
            switch self {
            case .invalidRequest: return "파일의 제한 사항과 맞지 않습니다."
            case .invalidAccessToken: return "유효하지 않은 액세스 토큰"
            case .forbidden: return "접근 권한 없음"
            case .dbServerObstacle: return "DB 서버 장애로 게시글이 저장되 않음"
            case .accessTokenExpiration: return "액세스 토큰 만료"
            }
        }
    }

    /// 포스트 조회 에러
    enum PostReadError: Int, NetworkAPIError {
        case invalidRequest = 400           // 잘못된 요청
        case invalidAccessToken = 401       // 유효하지 않은 액세스 토큰
        case forbidden = 403                // 접근 권한이 없음
        case accessTokenExpiration = 419    // 액세스 토큰 만료

        init?(statusCode: Int) {
            if let error = Self.init(rawValue: statusCode) {
                self = error
            } else {
                return nil
            }
        }

        var description: String {
            switch self {
            case .invalidRequest: return "잘못된 요청"
            case .invalidAccessToken: return "유효하지 않은 액세스 토큰"
            case .forbidden: return "접근 권한 없음"
            case .accessTokenExpiration: return "액세스 토큰 만료"
            }
        }
    }

}
