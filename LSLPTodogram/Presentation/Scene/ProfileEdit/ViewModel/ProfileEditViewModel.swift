//
//  ProfileEditViewModel.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/15.
//

import Foundation
import UIKit.UIImage
import RxCocoa
import RxSwift

final class ProfileEditViewModel: ViewModelType {
    private let disposeBag = DisposeBag()

    private let existingProfile = BehaviorRelay<Profile>(value: Profile(_id: "", nick: "", email: "", posts: [], followers: [], following: [], profileImageString: "", phoneNum: "", birthDay: ""))

    var profileImage: UIImage?

    struct Input {
        let nicknameText: ControlProperty<String>
        let phoneNumText: ControlProperty<String>
        let birthDayText: ControlProperty<String>
        let birthDayDate: ControlProperty<Date>
        let cancelBarButtonItemTapped: ControlEvent<Void>
        let completeBarButtonItemTapped: ControlEvent<Void>
    }

    struct Output {
        let isProfile: Observable<Profile>
        let nicknameState: PublishRelay<Result<Void, NicknameError>>
        let phoneNumState: PublishRelay<Result<Void, PhoneNumError>>
        let birthDayState: PublishRelay<Result<Void, BirthDayError>>
        let completeState: PublishRelay<Result<Void, Error>>
        let cancelState: PublishRelay<Bool>
        let npb: BehaviorRelay<Bool>
        let error: Driver<NetworkError>
    }

    func transform(input: Input) -> Output {
        let nicknameState = PublishRelay<Result<Void, NicknameError>>()
        let phoneNumState = PublishRelay<Result<Void, PhoneNumError>>()
        let birthDayState = PublishRelay<Result<Void, BirthDayError>>()
        let completeState = PublishRelay<Result<Void, Error>>()
        let cancelState = PublishRelay<Bool>()
        let npb = BehaviorRelay(value: false)

        let errorTracker = ErrorTracker()
        let errors = errorTracker
            .compactMap { $0 as? NetworkError }
            .asDriver()

        let token = BehaviorRelay(value: KeychainManager.read(key: KeychainKey.token.rawValue) ?? "")

        let isProfile = token
            .flatMapLatest { _ in
                return NetworkManager.shared.request(
                    type: ProfileResponseDTO.self,
                    api: ProfileRouter.read
                )
                .catch { error in
                    print("❌", error.localizedDescription)
                    return Single.never()
                }
            }
            .withUnretained(self)
            .map { (owner, response) in
                return response.toDomain()
            }

        isProfile
            .bind(to: existingProfile)
            .disposed(by: disposeBag)

        input.nicknameText
            .withLatestFrom(existingProfile) { (nickname: $0, existing: $1.nick) }
            .flatMapLatest {
                return AccountValidator.shared.validate(
                    nickname: $0.nickname,
                    existing: $0.existing
                )
                .catch { error in
                    if let error = error as? NicknameError {
                        nicknameState.accept(.failure(error))
                    }
                    return Single.never()
                }
            }
            .bind(with: self) { owner, void in
                nicknameState.accept(.success(void))
            }
            .disposed(by: disposeBag)

        input.phoneNumText
            .withLatestFrom(existingProfile) { (phoneNum: $0, existing: $1.phoneNum) }
            .flatMapLatest {
                return AccountValidator.shared.validate(
                    phoneNum: $0.phoneNum,
                    existing: $0.existing
                )
                .catch { error in
                    if let error = error as? PhoneNumError {
                        phoneNumState.accept(.failure(error))
                    }
                    return Single.never()
                }
            }
            .bind(with: self) { owner, void in
                phoneNumState.accept(.success(void))
            }
            .disposed(by: disposeBag)

        input.birthDayText
            .withLatestFrom(existingProfile) { (birthDay: $0, existing: $1.birthDay) }
            .flatMapLatest {
                return AccountValidator.shared.validate(
                    birthDay: $0.birthDay,
                    existing: $0.existing
                )
                .catch { error in
                    if let error = error as? BirthDayError {
                        birthDayState.accept(.failure(error))
                    }
                    return Single.never()
                }
            }
            .bind(with: self) { owner, void in
                birthDayState.accept(.success(void))
            }
            .disposed(by: disposeBag)

        input.birthDayDate
            .skip(1)
            .filter { $0 <= Date() }
            .withUnretained(self)
            .map { $0.0.dateFormat(date: $0.1) }
            .bind(to: input.birthDayText)
            .disposed(by: disposeBag)

        // nickname, phoneNum, birthDay, existingProfile
        let npbp = Observable
            .combineLatest(
                input.nicknameText,
                input.phoneNumText,
                input.birthDayText,
                existingProfile
            )

        // 있는 것만 검사하고 업데이트 쳐버려
        let profileEditTrigger = input.completeBarButtonItemTapped.share()

        let nickname = profileEditTrigger
            .withLatestFrom(input.nicknameText)

        let phoneNum = profileEditTrigger
            .withLatestFrom(input.phoneNumText)

        let birthDay = profileEditTrigger
            .withLatestFrom(input.birthDayText)

        let profileImage = profileEditTrigger
            .withUnretained(self)
            .map { (owner, _) in owner.profileImage }

        Observable
            .combineLatest(nickname, phoneNum, birthDay, profileImage)
            .map { value in
                let request: ProfileUpdateRequest
                if let profileImage = value.3 {
                    request = ProfileUpdateRequest(
                        nick: value.0,
                        phoneNum: value.1,
                        birthDay: value.2,
                        files: [profileImage]
                    )
                } else {
                    request = ProfileUpdateRequest(
                        nick: value.0,
                        phoneNum: value.1,
                        birthDay: value.2,
                        files: nil
                    )
                }
                return request
            }
            .flatMapLatest {
                return NetworkManager.shared.upload(
                    type: ProfileResponseDTO.self,
                    api: ProfileRouter.update(body: $0)
                )
                .trackError(errorTracker)
                .catch { _ in Observable.empty() }
                .map { $0.toDomain() }
            }
            .bind(with: self) { owner, profile in
                print("변경되었습니다.")
            }
            .disposed(by: disposeBag)



//        input.completeBarButtonItemTapped
//            .withLatestFrom(npbp) { (nickname: $1.0, phoneNum: $1.1, birthDay: $1.2, existing: $1.3) }
//            .flatMapLatest {
//                return AccountValidator.shared.validate(
//                    nickname: $0.nickname,
//                    phoneNum: $0.phoneNum,
//                    birthDay: $0.birthDay,
//                    existing: $0.existing
//                )
//                .catch { error in
//                    completeState.accept(.failure(error))
//                    return Single.never()
//                }
//            }
//            .withLatestFrom(token) { body, token in
//                return (token: token, body: body)
//            }
//            .flatMapLatest {
//                return NetworkManager.shared.upload(
//                    type: ProfileResponseDTO.self,
//                    api: ProfileRouter.update(body: $0.body)
//                )
//                .catch { error in
//                    print("❌ 네트워크 에러 ", error.localizedDescription)
//                    completeState.accept(.failure(error))
//                    return Single.never()
//                }
//            }
//            .map { _ in Void() }
//            .bind(with: self) { owner, void in
//                completeState.accept(.success(void))
//            }
//            .disposed(by: disposeBag)
//
//        input.cancelBarButtonItemTapped
//            .withLatestFrom(npbp) { (nickname: $1.0, phoneNum: $1.1, birthDay: $1.2) }
//            .map {
//                if $0.nickname.isEmpty && $0.phoneNum.isEmpty && $0.birthDay.isEmpty {
//                    return true
//                } else {
//                    return false
//                }
//            }
//            .bind(to: cancelState)
//            .disposed(by: disposeBag)
//
//        npbp
//            .map { (nickname: $0.0, phoneNum: $0.1, birthDay: $0.2) }
//            .map {
//                if $0.nickname.isEmpty && $0.phoneNum.isEmpty && $0.birthDay.isEmpty {
//                    return false
//                } else {
//                    return true
//                }
//            }
//            .bind(to: npb)
//            .disposed(by: disposeBag)

        return Output(
            isProfile: isProfile,
            nicknameState: nicknameState,
            phoneNumState: phoneNumState,
            birthDayState: birthDayState,
            completeState: completeState,
            cancelState: cancelState,
            npb: npb,
            error: errors
        )
    }

}

private extension ProfileEditViewModel {

    private func dateFormat(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"

        return formatter.string(from: date)
    }

}
