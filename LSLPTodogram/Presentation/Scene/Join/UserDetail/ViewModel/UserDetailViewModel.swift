//
//  UserDetailViewModel.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/11/23.
//

import Foundation
import RxCocoa
import RxSwift

final class UserDetailViewModel: ViewModelType {
    private let disposeBag = DisposeBag()

    let join = PublishRelay<(nickname: String, phoneNum: String?, birthDay: String?)>()
    let scrollToPrev = PublishRelay<Void>()

    struct Input {
        let nicknameText: ControlProperty<String?>
        let phoneNumText: ControlProperty<String?>
        let birthDayText: ControlProperty<String?>
        let birthDayDate: ControlProperty<Date>
        let joinButtonTapped: ControlEvent<Void>
        let prevButtonTapped: ControlEvent<Void>
    }

    struct Output {
        let nicknameState: PublishRelay<Result<Void, NicknameError>>
        let phoneNumState: PublishRelay<Result<Void, PhoneNumError>>
        let birthDayState: PublishRelay<Result<Void, BirthDayError>>
        let windowReset: PublishRelay<Void>
    }

    func transform(input: Input) -> Output {
        let nicknameState = PublishRelay<Result<Void, NicknameError>>()
        let phoneNumState = PublishRelay<Result<Void, PhoneNumError>>()
        let birthDayState = PublishRelay<Result<Void, BirthDayError>>()
        let windowReset = PublishRelay<Void>()

        input.nicknameText
            .orEmpty
            .filter {
                if $0.isEmpty {
                    nicknameState.accept(.failure(.empty))
                    return false
                }
                return true
            } // 닉네임 존재 여부 검사
            .bind(with: self) { owner, nickname in
                if owner.isValidNickname(nickname) {
                    nicknameState.accept(.success(Void()))
                } else {
                    nicknameState.accept(.failure(.invalid))
                }
            }
            .disposed(by: disposeBag)

        input.phoneNumText
            .orEmpty
            .filter {
                if $0.isEmpty {
                    phoneNumState.accept(.failure(.empty))
                    return false
                }
                return true
            } // 핸드폰 번호 존재 여부 검사
            .bind(with: self) { owner, phoneNum in
                if owner.isValidPhoneNum(phoneNum) {
                    phoneNumState.accept(.success(Void()))
                } else {
                    phoneNumState.accept(.failure(.invalid))
                }
            }
            .disposed(by: disposeBag)

        input.birthDayText
            .orEmpty
            .filter {
                if $0.isEmpty {
                    birthDayState.accept(.failure(.empty))
                    return false
                }
                return true
            } // 생년월일 존재 여부 검사
            .bind(with: self) { owner, birthDay in
                if owner.isValidBirthday(birthDay) {
                    birthDayState.accept(.success(Void()))
                } else {
                    birthDayState.accept(.failure(.invalid))
                }
            }
            .disposed(by: disposeBag)

        input.birthDayDate
            .skip(1) // TODO: 두 번 찍혀서 startWith("")를 사용하지 못했는데 skip(1)은 왜 되고 startWith("")는 왜 안됬는지 확인해보자!
            .filter { $0 <= Date() }
            .withUnretained(self)
            .map { $0.0.dateFormat(date: $0.1) }
            .bind(to: input.birthDayText)
            .disposed(by: disposeBag)

        // 핸드폰 번호 + 생년월일
        let phoneNumAndBirthDay = Observable
            .combineLatest(
                input.phoneNumText.orEmpty,
                input.birthDayText.orEmpty
            )

        // 가입 버튼을 눌렀을 때
        let nicknameCheckFlow = input.joinButtonTapped
            .withLatestFrom(input.nicknameText.orEmpty) // 닉네임은 필수
            .filter {
                if $0.isEmpty {
                    nicknameState.accept(.failure(.empty))    // 없다면 empty 에러
                    return false
                }
                return true
            } // 닉네임 존재 여부 검사
            .filter { [weak self] (nickname) in
                guard let owner = self else {return false}
                if !owner.isValidNickname(nickname) {
                    nicknameState.accept(.failure(.invalid))  // 유효하지 않다면 invalid 에러
                    return false
                }
                return true
            } // 닉네임 유효성 검사
            .withLatestFrom(phoneNumAndBirthDay) { nickname, phoneNumAndBirthDay in
                return (nickname: nickname, phoneNum: phoneNumAndBirthDay.0, birthDay: phoneNumAndBirthDay.1)
            }
            .share()

        // 1. 핸드폰 번호만 있다면
        nicknameCheckFlow
            .filter { !$0.phoneNum.isEmpty && $0.birthDay.isEmpty }
            .filter { [weak self] in
                guard let owner = self else {return false}
                if !owner.isValidPhoneNum($0.phoneNum) {
                    phoneNumState.accept(.failure(.invalid)) // 유효하지 않다면 invalid 에러
                    return false
                }
                return true
            } // 핸드폰 유효성 검사
            .bind(with: self) { $0.join.accept(($1.nickname, $1.phoneNum, nil)) }
            .disposed(by: disposeBag)

        // 2. 생년월일만 있다면
        nicknameCheckFlow
            .filter { $0.phoneNum.isEmpty && !$0.birthDay.isEmpty }
            .filter { [weak self] in
                guard let owner = self else {return false}
                if !owner.isValidBirthday($0.birthDay) {
                    birthDayState.accept(.failure(.invalid)) // 유효하지 않다면 invalid 에러
                    return false
                }
                return true
            } // 생년월일 유효성 검사
            .bind(with: self) { $0.join.accept(($1.nickname, nil, $1.birthDay)) }
            .disposed(by: disposeBag)

        // 3. 둘 다 있다면
        nicknameCheckFlow
            .filter { !$0.phoneNum.isEmpty && !$0.birthDay.isEmpty }
            .filter { [weak self] in
                guard let owner = self else {return false}
                if !owner.isValidPhoneNum($0.phoneNum) {
                    phoneNumState.accept(.failure(.invalid)) // 유효하지 않다면 invalid 에러
                    return false
                }
                return true
            } // 핸드폰 유효성 검사
            .filter { [weak self] in
                guard let owner = self else {return false}
                if !owner.isValidBirthday($0.birthDay) {
                    birthDayState.accept(.failure(.invalid)) // 유효하지 않다면 invalid 에러
                    return false
                }
                return true
            } // 생년월일 유효성 검사
            .bind(with: self) { $0.join.accept(($1.nickname, $1.phoneNum, $1.birthDay)) }
            .disposed(by: disposeBag)

        // 4. 둘 다 없다면
        nicknameCheckFlow
            .filter { $0.phoneNum.isEmpty && $0.birthDay.isEmpty }
            .bind(with: self) { $0.join.accept(($1.nickname, nil, nil)) }
            .disposed(by: disposeBag)

        // 이전으로
        input.prevButtonTapped
            .bind(with: self) { owner, void in
                owner.scrollToPrev.accept(void)
            }
            .disposed(by: disposeBag)

        join
            .map { _ in Void() }
            .bind(to: windowReset)
            .disposed(by: disposeBag)

        return Output(
            nicknameState: nicknameState,
            phoneNumState: phoneNumState,
            birthDayState: birthDayState,
            windowReset: windowReset
        )
    }

    private func isValidNickname(_ nickname: String) -> Bool {
        let nicknameRegex = "^[a-zA-Z0-9가-힣_]{2,20}$"   // 한글, 영어, 숫자, _만 사용 가능, 최소 2글자 ~ 최대 20글자
        let nicknamePredicate = NSPredicate(format: "SELF MATCHES %@", nicknameRegex)
        return nicknamePredicate.evaluate(with: nickname)
    }

    private func isValidPhoneNum(_ phoneNum: String) -> Bool {
        let phoneRegex = "^01(?:0|1|[6-9])(?:\\d{3}|\\d{4})\\d{4}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phonePredicate.evaluate(with: phoneNum)
    }

    private func isValidBirthday(_ birthday: String) -> Bool {
        let birthdayRegex = #"^\d{4}년 \d{2}월 \d{2}일$"#
        let birthdayPredicate = NSPredicate(format: "SELF MATCHES %@", birthdayRegex)
        return birthdayPredicate.evaluate(with: birthday)
    }

    private func dateFormat(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"

        return formatter.string(from: date)
    }

}
