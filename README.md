# Bupgram

> 일상을 공유하고 유저끼리 소통할 수 있는 Thread 기반의 SNS앱입니다.

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
- 회원인증

## 🛠 구현 기술

- `Alamofire`를 기반으로 `multipart/form-data` 형식을 사용하여 `이미지를 업로드` 구현
- `AuthenticationInterceptor`를 활용해 `JWT` 기반의 `AccessToken` 갱신과 `RefreshToken` 만료 로직 구현
- `cursor`기반 페이지네이션 구현
- `Keychain`을 활용하여 `AccessToken`과 `RefreshToken`의 `CRUD` 구현
- `Optimistic UI` 구현

## 💻 기술 스택

- `Swift`
- `MVVM`, `Router`, `Input-Output`, `Singleton`
- `UIKit`, `PhotosUI`
- `Codable`, `CodeBase UI`, `AutoLayout`, `DiffableDataSource`, `CompositionalLayout`, `Keychain`
- `RxSwift`, `RxDataSource`, `Alamofire`, `SnapKit`, `Kingfisher`, `Tabman`, `IQKeyboardManager`, `PanModal`

## 📱 서비스

- 최소 버전 : iOS 15.0
- 개발 인원 : 1인
- 개발 기간 : 2023년 11월 20일 ~ 2023년 12월 20일 (1개월)

## 🚧 기술적 도전

// 기술적 도전
// 1. 옽티머시기 ui 구현한고 (좋아요, 팔로우)
// 2. 인터셉터

// 트러블 슈팅
// 1. 여기에 그 레이아웃 업데이트가 와야제 
// 2. multipart/form-data` 형식을 사용하여 `이미지를 업로드` 구현

<!-- 프로젝트를 진행하면서 겪은 기술적인 도전과 어떻게 해결했는지에 대한 설명을 추가한다. -->
### 1. `AuthenticationInterceptor`를 활용해 `JWT` 기반의 `AccessToken` 갱신과 `RefreshToken` 만료 로직 구현
- **도전 상황**</br>
대부분의 API 요청 Header에 `AccessToken`을 넣어줘야 했습니다. 매번 요청 로직을 작성할 때마다 Keychain에 저장된 `token`을 넣어주고, 매번 에러 핸들링 하는게 불편하게 느껴졌습니다. 이 불편함을 개선하기 위해 Alamofire 5.2에 등장한 `AuthenticationInterceptor`를 적용해 보았습니다.

- **도전 결과**</br>
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

## 🛠 트러블 슈팅

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
1. **Alamofire AuthenticationInterceptor를 활용한 JWT AccessToken 만료 갱신, RefreshToken 만료 로직 처리**</br>

🤔 개선할 점
1. ****</br>
2. ****</br>

## 🖼 아이콘 출처 및 저작권 정보

이 프로젝트에서 사용된 아이콘들은 아래와 같은 출처에서 제공되었습니다. 각 아이콘의 저작권은 해당 제작자에게 있습니다. 아이콘을 사용하려면 각 아이콘의 출처로 이동하여 저작권 관련 정보를 확인하세요.
