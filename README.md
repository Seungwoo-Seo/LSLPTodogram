# Bupgram

> 일상을 공유하고 유저끼리 소통할 수 있는 SNS앱입니다.

<!--
<p align="center">
  <img src="https://github.com/Seungwoo-Seo/ExemplaryRestaurantIB/assets/72753868/f7674e21-7dab-4d82-b0f3-17434679f683" width="130">
  <img src="https://github.com/Seungwoo-Seo/ExemplaryRestaurantIB/assets/72753868/e50718e4-8afc-4c1d-bbce-ef2a8aca5024" width="130">
  <img src="https://github.com/Seungwoo-Seo/ExemplaryRestaurantIB/assets/72753868/90ae0dcd-99ab-462b-b0a1-b3653c8827cc" width="130">
  <img src="https://github.com/Seungwoo-Seo/ExemplaryRestaurantIB/assets/72753868/a7fb2876-dc56-4ce7-a9cc-1c5dd1e99f89" width="130">
  <img src="https://github.com/Seungwoo-Seo/ExemplaryRestaurantIB/assets/72753868/0db88594-bb32-46ec-8346-3ce1b01da748" width="130">
  <img src="https://github.com/Seungwoo-Seo/ExemplaryRestaurantIB/assets/72753868/184e3b7d-8b74-4228-b2f3-767c618a9e7d" width="130">
</p>
-->

## 목차

- [🚀 주요 기능](#-주요-기능)
- [💻 기술 스택](#-기술-스택)
- [📱 서비스](#-서비스)
- [🚧 기술적 도전](#-기술적-도전)
- [🛠 트러블 슈팅](#-트러블-슈팅)
- [📝 회고](#-회고)
- [🖼 아이콘 출처 및 저작권 정보](#-아이콘-출처-및-저작권-정보)

## 🚀 주요 기능

- 게시글 목록 및 상세 정보 조회
- 본인과 타인의 게시글에 좋아요/취소
- 본인과 타인의 게시글에 댓글 CRUD
- 타인 계정 팔로우/언팔로우
- 해시태그
- 회원인증

## 🛠 구현 기능

- `multipart/form-data` 형식을 사용하여 `이미지를 업로드` 구현
- `AuthenticationInterceptor`를 활용해 `JWT` 기반의 `AccessToken` 갱신과 `RefreshToken` 만료 구현
- `cursor`기반 페이지네이션 구현
- `Keychain`을 활용하여 `AccessToken`과 `RefreshToken`의 `CRUD` 구현
- `Optimistic UI` 구현

## 💻 기술 스택

- `Swift`
- `MVVM`, `Router`, `Input-Output`, `Singleton`
- `UIKit`, `PhotosUI`
- `CodeBase UI`, `AutoLayout`
- `Codable`, `DiffableDataSource`, `CompositionalLayout`, `Keychain`
- `RxSwift`, `RxDataSource`, `Alamofire`, `SnapKit`, `Kingfisher`, `Tabman`, `IQKeyboardManager`, `PanModal`

## 📱 서비스

- 최소 버전 : iOS 15.0
- 개발 인원 : 1인
- 개발 기간 : 2023년 11월 20일 ~ 2023년 12월 20일 (1개월)

## 🚧 기술적 도전

// 기술적 도전
// 1. 옽티머시기 ui 구현한고 (좋아요, 팔로우)
// 2. 인터셉

// 트러블 슈팅
// 1. 여기에 그 레이아웃 업데이트가 와야제 
// 2. multipart/form-data` 형식을 사용하여 `이미지를 업로드` 구현

<!-- 프로젝트를 진행하면서 겪은 기술적인 도전과 어떻게 해결했는지에 대한 설명을 추가한다. -->
### 1. `AuthenticationInterceptor`를 활용해 `JWT` 기반의 `AccessToken` 갱신과 `RefreshToken` 만료 로직 개선하기
- **도전 상황**</br>
대부분의 API 요청 Header에 `AccessToken`을 넣어줘야 했습니다. AccessToken 만료 시(419) `RefreshToken`으로 재요청 로직과 리프레시 토큰 마저 만료 시 `로그인 화면으로 전환` 로직이 필요했습니다. 매 요청마다 중복된 코드를 개선하고 싶었고 Alamofire 5.2에 등장한 `AuthenticationInterceptor`를 적용해 보았습니다.

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

## 🛠 트러블 슈팅

### 1. `interceptor` 구현 후 서버로부터 419(액세스 토큰 만료)를 응답 받았을 때 `무한 재귀` 이슈
- **문제 상황**</br>
Alamofire에서 제공해주는 `AuthenticationInterceptor`를 적용하여 액세스 토큰 만료 시 리프레시 토큰으로 토큰 갱신 요청을 보냈었습니다. 그런데 이 때 `무한 재귀`에 걸리면서 어마어마한 요청을 보내게 되고 서버로부터 429(과호출)을 응답 받게 되었습니다.

- **문제 원인**</br>
액세스 토큰 만료 시 리프레시 토큰으로 갱신 요청 로직을 `Authenticator` 객체의 `refresh 메서드`에서 작성하고, 여기서 받은 응답을 `completion으로 전달`하게 되는데, completion으로 `error`를 전달 받게 되면 Alamofire 내부적으로 `retry`를 하게 됩니다. 그런데! 여기서 제가 인터셉터를 사용한 request 메서드를 또 사용해서 무한 재귀에 걸리게 되는 것이였습니다.

- **해결 방법**</br>
이미 interceptor가 `419를 잡아서` 이 Flow를 타게 된 것이기 때문에 리프래시 토큰으로 액세스 토큰 갱신 요청을 보낼 땐 interceptor를 `사용하지 않는` request 메서드를 사용하므로 해결했습니다.
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

<!-- 프로젝트 중 발생한 문제와 그 해결 방법에 대한 내용을 기록한다. -->
### 1. 좋아요 이벤트가 발생하면 모든 request를 보낼 것인가?
- **문제 상황**</br>

- **해결 방법**</br>

~~~swift
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
        // MARK: 현재로썬 굳이 response 값을 사용할 필요가 없어졌다.
    }
    .disposed(by: disposeBag)

input.likeState
    .bind(with: self) { owner, localLikeState in
        owner.likeState.updateValue(localLikeState.isSelected, forKey: localLikeState.row)
    }
    .disposed(by: disposeBag)
~~~

### 2. 팔로우
- **문제 상황**</br>
- **해결 방법**</br>
~~~swift
~~~

### 3. multipart

## 📝 회고

<!-- 프로젝트를 마무리하면서 느낀 소회, 개선점, 다음에 시도해보고 싶은 것 등을 정리한다. -->
프로젝트를 마무리하면서 몇 가지 느낀 점과 개선할 사항들을 회고로 정리하겠습니다.

👍 성취한 점
1. **Alamofire AuthenticationInterceptor를 활용한 JWT AccessToken 만료 갱신, RefreshToken 만료 처리**</br>

🤔 개선할 점
1. ****</br>
2. ****</br>

## 🖼 아이콘 출처 및 저작권 정보

이 프로젝트에서 사용된 아이콘들은 아래와 같은 출처에서 제공되었습니다. 각 아이콘의 저작권은 해당 제작자에게 있습니다. 아이콘을 사용하려면 각 아이콘의 출처로 이동하여 저작권 관련 정보를 확인하세요.
