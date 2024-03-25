# Bupgram

> Bup(Burning Passion)을 공유하고 소통할 수 있는 SNS 서비스

<p align="center">
  <img src="https://github.com/Seungwoo-Seo/LSLPTodogram/assets/72753868/1b62cbf6-3c4c-4d74-8629-76912faa8edf" width="130">
  <img src="https://github.com/Seungwoo-Seo/LSLPTodogram/assets/72753868/32f9cbbd-a750-4bf3-a400-b85e00ba3eed" width="130">
  <img src="https://github.com/Seungwoo-Seo/LSLPTodogram/assets/72753868/eda01cb4-8001-4854-b9b1-8c20b7ad9c0a" width="130">
  <img src="https://github.com/Seungwoo-Seo/LSLPTodogram/assets/72753868/6b3a4956-c8a2-4547-83e4-02b8c77d90a1" width="130">
  <img src="https://github.com/Seungwoo-Seo/LSLPTodogram/assets/72753868/10127fd9-6d4e-405a-a22d-458be6659808" width="130">
  <img src="https://github.com/Seungwoo-Seo/LSLPTodogram/assets/72753868/f24d0a7c-7ef5-4350-90e0-7a394cb70dce" width="130">
</p>

|메인 화면|본인 계정|게시글(Bup 작성)|댓글 작성|타인 계정|회원인증|
|:---:|:---:|:---:|:---:|:---:|:---:|
|<img src="https://github.com/Seungwoo-Seo/LSLPTodogram/assets/72753868/b17127b8-6c28-495c-8bab-477e2b81c0b0" width="150">|<img src="https://github.com/Seungwoo-Seo/LSLPTodogram/assets/72753868/fb58ef70-d0b5-45d1-a573-382c73dfc8e1" width="150">|<img src="https://github.com/Seungwoo-Seo/LSLPTodogram/assets/72753868/e85dcccb-5258-4f9a-b51a-bee5f090647c" width="150">|<img src="https://github.com/Seungwoo-Seo/LSLPTodogram/assets/72753868/89689a2f-ba5f-4705-9cf1-a6802485f736" width="150">|<img src="https://github.com/Seungwoo-Seo/LSLPTodogram/assets/72753868/cae74492-0b01-49d3-a798-91ac7e73c7d3" width="150">|<img src="https://github.com/Seungwoo-Seo/LSLPTodogram/assets/72753868/90168835-5fa0-447e-bb93-23a9df9a3c12" width="150">|

## 📱 서비스

- 최소 버전 : iOS 15.0
- 개발 인원 : 1인
- 개발 기간 : 2023년 11월 20일 ~ 2024년 1월 5일 (7주)

## 🚀 서비스 기능

- 이메일 회원인증 기능 제공
- 게시글(Bup) 작성/조회/삭제/해시태그 기능 제공
- 게시글 좋아요/댓글 기능 제공
- 계정 팔로우/언팔로우 기능 제공

## 🛠 사용 기술

- Swift
- UIKit, PhotosUI
- MVVM, Input/Output Pattern, Router Pattern, Singleton
- RxSwift, RxDataSource, Alamofire, SnapKit, Kingfisher, Tabman, IQKeyboardManager, PanModal
- CodeBase UI, AutoLayout, Base, ViewIdentifiable, CompositionalLayout, DiffableDataSource, Codable, Keychain

## 💻 핵심 설명

- RxSwift + MVVM 구조 기반 `Input/Output Pattern` 적용
- Alamofire 기반 `Router Pattern` 적용, `Generic request` 메서드 구현
- multipart/form-data 기반 `이미지 업로드` 및 `다운 샘플링` 구현
- AuthenticationInterceptor 사용해 JWT 기반 `AccessToken 갱신/RefreshToken 만료` 로직 구현
- Keychain을 통한 Auth토큰 `암호화 저장` 및 업데이트 구현
- cursor 기반 `페이지 네이션`을 통한 게시글 로드
- 이미지 개수에 따른 `CollectionViewLayout 변경` 및 `Image Cell Sizing` 구현
- Rx throttle operater + Dictionary를 통한 좋아요/팔로우 `Optimistic UI` 구현

## 🚧 기술적 도전

<!-- 프로젝트를 진행하면서 겪은 기술적인 도전과 어떻게 해결했는지에 대한 설명을 추가한다. -->
### 1. `AuthenticationInterceptor`를 활용해 `JWT` 기반의 `AccessToken` 갱신과 `RefreshToken` 만료 로직 개선하기
- **도전 상황**</br>
AccessToken 만료 시(419) `RefreshToken`으로 재요청 로직과 리프레시 토큰 마저 만료 시 `로그인 화면으로 전환` 로직이 필요했습니다. 매 요청마다 중복된 코드를 개선하고 싶었고 Alamofire 5.2에 등장한 `AuthenticationInterceptor`를 적용해 보았습니다.

- **도전 결과**</br>
interceptor를 외부에서 만들어서 request 메서드 파라미터로 전달해주는 것만으로 모든 처리가 가능케 되었습니다.
~~~swift
import Foundation
import Alamofire

struct SesacAuthenticationCredential: AuthenticationCredential {
    let accessToken: String
    let refreshToken: String

    var requiresRefresh: Bool = false
}
~~~
~~~swift
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
    }

    func refresh(
        _ credential: SesacAuthenticationCredential,
        for session: Alamofire.Session,
        completion: @escaping (Result<SesacAuthenticationCredential, Error>) -> Void
    ) {
        NetworkManager.shared.request(
            type: RefreshResponse.self,
            api: AccountRouter.refresh(refreshToken: credential.refreshToken)
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
~~~
~~~swift
final class NetworkManager {
    ...

    func request<T: Decodable, E: NetworkAPIError>(
        type: T.Type,
        api: URLRequestConvertible,
        error: E.Type,
        interceptor: AuthenticationInterceptor<SesacAuthenticator>
    ) -> Single<T> {
        return Single<T>.create { observer in
            AF
                .request(api, interceptor: interceptor)
                .validate(statusCode: 200...299)
                .responseDecodable(of: type) { [weak self] (response) in
                    guard let self else {return}
                    switch response.result {
                    case .success(let success):
                        observer(.success(success))

                    case .failure(let afError):
                        self.handleNetworkError(error: afError, observer: observer, errorType: error)
                    }
                }

            return Disposables.create()
        }
    }

    ...
}
~~~

### 2. Optimistic UI 도전
- **도전 상황**</br>
좋아요와 팔로우/언팔로우의 경우 사용자가 해당 버튼들을 누를 때마다 서버와 통신을 한다는게 리소스 낭비지 않을까? 라고 생각했습니다. 또, 만약 악성 사용자가 수천, 수만번 좋아요/팔로우/언팔로우를 한다면 생각지도 못한 트래픽이 발생하고 그것은 곧 `비용 이슈`가 발생할 수 있겠다라는 결론을 얻었었습니다. 그래서 키워드를 찾던 중 `Optimistic UI`를 알게 되었고 적용해 보았습니다.

- **도전 결과**</br>
좋아요 이벤트가 발생하면 서버의 `응답을 기다리지 않고` `즉각 UI를 업데이트` 하고, 무분별한 API request를 방지하기 위해 `throttle operator` 사용해 구현했습니다.
~~~swift
// ViewController

// 좋아요 버튼 누르면
let didTapLikeButton = cell.communicationButtonStackView.likeButton.rx.tap
    .scan(item.isIliked) { lastState, _ in !lastState } // isSelected 상태 토글
    .flatMapLatest { isSelected in
        Observable<Void>.create { observer in
            // UI 업데이트
            cell.communicationButtonStackView.likeButton.isSelected = isSelected
            let countString = item.localLikesCountString(isSelected: isSelected)
            cell.countButtonStackView.likeCountButton.updateTitle(title: countString)
            observer.onNext(Void())
            observer.onCompleted()
            return Disposables.create()
        }
    }
    .share()

let rowAndIsSelected = Observable.combineLatest(
    Observable.just(row),
    cell.communicationButtonStackView.likeButton.rx.observe(\.isSelected)
)

// 이벤트가 발생한 좋아요 버튼의 정보를 viewModel로 전달
didTapLikeButton
    .withLatestFrom(rowAndIsSelected)
    .bind(with: self) { owner, rowAndIsSelected in
        likeState.accept(rowAndIsSelected)
    }
    .disposed(by: cell.disposeBag)

// 무분별한 API request를 방지하기 위해 throttle operator 사용
didTapLikeButton
    .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
    .withLatestFrom(Observable.just(item.id))
    .bind(to: didTapLikeButtonOfId)
    .disposed(by: cell.disposeBag)
~~~
~~~swift
// ViewModel

input.didTapLikeButtonOfId
    .flatMapLatest { (id) in
        return NetworkManager.shared.request(
            type: LikeUpdateResponseDTO.self,
            api: LikeRouter.update(id: id),
            error: NetworkError.LikeUpdateError.self
        )
        .trackActivity(activityIndicator)
        .trackError(errorTracker)
        .catch { _ in Observable.empty() }
        .map { $0.toDomain() }
    }
    .withLatestFrom(input.likeState) { (domain: $0, likeState: $1) }
    .bind(with: self) { owner, value in
        // MARK: 굳이 response 값을 사용할 필요가 없어졌다.
    }
    .disposed(by: disposeBag)

input.likeState
    .bind(with: self) { owner, localLikeState in
        owner.likeState.updateValue(localLikeState.isSelected, forKey: localLikeState.row)
    }
    .disposed(by: disposeBag)
~~~


## 🚨 트러블 슈팅

### 1. Single로 랩핑한 REST API request를 catch operator로 에러 핸들링 시 스트림 종료 이슈
- **문제 원인**</br>
flatMapLatest 외부에서 catch operator 사용하여 completed 이벤트 방출 후 스트림 종료

- **해결 방법**</br>
flatMapLatest 내부에서 catch operator로 에러 핸들링 및 스트림 유지
~~~swift
.flatMapLatest { [unowned self] _ in
    return NetworkManager.shared.request(
        type: PostReadResponseDTO.self,
        api: PostRouter.read(parameters: self.baseParameters),
        error: NetworkError.PostReadError.self
    )
    .catch { _ in Single.never() }
}
~~~

### 2. AuthenticationInterceptor 기반 interceptor 구현 후 서버로부터 419(액세스 토큰 만료)를 응답받았을 때 무한 재귀 이슈
- **문제 원인**</br>
419를 잡았을 때 interceptor retry에서 갱신 request를 보낼 때도 interceptor를 사용했던 상황이 원인
  
- **해결 방법**</br>
이미 419를 잡았기 때문에 리프래시 토큰으로 갱신 요청을 보낼 땐 interceptor를 `사용하지 않는` request 메서드를 사용해서 해결
~~~swift
final class SesacAuthenticator: Authenticator {
    ...

    func refresh(
        _ credential: SesacAuthenticationCredential,
        for session: Alamofire.Session,
        completion: @escaping (Result<SesacAuthenticationCredential, Error>) -> Void
    ) {
        NetworkManager.shared.request(
            type: RefreshResponse.self,
            api: AccountRouter.refresh(refreshToken: credential.refreshToken)
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

    ...
}
~~~

<!--
## 📝 회고
- `RxSwift`를 적용하여 `반응형 프로그래밍`에 대한 플로우를 경험
- `JWT`를 활용한 `사용자 인증` 플로우를 경험
- `Optimistic UI`를 통해 트래픽 감소 및 비용 절감 효과를 경험
- `Router 패턴`을 통해 네트워크 레이어의 가독성 및 재사용성 향상을 경험
- 프로젝트 규모가 커질수록 viewModel도 비대해졌고 viewModel에도 개선이 필요하다는 걸 경험
-->
