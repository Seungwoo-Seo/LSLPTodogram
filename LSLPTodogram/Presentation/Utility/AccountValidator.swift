//
//  AccountValidator.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/17.
//

import Foundation
import RxSwift

final class AccountValidator {
    static let shared = AccountValidator()

    private init() {}

    // MARK: - nickname

    func validate(nickname: String) -> Single<Void> {
        return Single.create { [weak self] (observer) in
            guard let self else {return Disposables.create()}

            if !nickname.isEmpty {
                if !self.isValidNickname(nickname) {
                    observer(.failure(NicknameError.invalid))
                }
            }

            observer(.success(Void()))

            return Disposables.create()
        }
    }

    func validate(nickname: String, existing: String) -> Single<Void> {
        return Single.create { [weak self] (observer) in
            guard let self else {return Disposables.create()}

            if !nickname.isEmpty {
                if !self.isValidNickname(nickname) {
                    observer(.failure(NicknameError.invalid))
                }

                if existing == nickname {
                    observer(.failure(NicknameError.same))
                }
            }

            observer(.success(Void()))

            return Disposables.create()
        }
    }

    // MARK: - phoneNum

    func validate(phoneNum: String, existing: String?) -> Single<Void> {
        return Single.create { [weak self] (observer) in
            guard let self else {return Disposables.create()}

            if !phoneNum.isEmpty {
                if !self.isValidPhoneNum(phoneNum) {
                    observer(.failure(PhoneNumError.invalid))
                }

                if let existing = existing {
                    if existing == phoneNum {
                        observer(.failure(PhoneNumError.same))
                    }
                }
            }

            observer(.success(Void()))

            return Disposables.create()
        }
    }

    // MARK: - birthDay

    func validate(birthDay: String, existing: String?) -> Single<Void> {
        return Single.create { [weak self] (observer) in
            guard let self else {return Disposables.create()}

            if !birthDay.isEmpty {
                if !self.isValidBirthday(birthDay) {
                    observer(.failure(BirthDayError.invalid))
                }

                if let existing = existing {
                    if existing == birthDay {
                        observer(.failure(BirthDayError.same))
                    }
                }
            }

            observer(.success(Void()))

            return Disposables.create()
        }
    }

    // MARK: - nickname + phoneNum + birthDay

    func validate(
        nickname: String,
        phoneNum: String,
        birthDay: String,
        existing: Profile
    ) -> Single<ProfileUpdateRequest> {
        return Single.create { [weak self] (observer) in
            guard let self else {return Disposables.create()}
            if !nickname.isEmpty {
                if !self.isValidNickname(nickname) {
                    observer(.failure(NicknameError.invalid))
                }

                if existing.nick == nickname {
                    observer(.failure(NicknameError.same))
                }
            }

            if !phoneNum.isEmpty {
                if !self.isValidPhoneNum(phoneNum) {
                    observer(.failure(PhoneNumError.invalid))
                }

                if let existingPhoneNum = existing.phoneNum {
                    if existingPhoneNum == phoneNum {
                        observer(.failure(PhoneNumError.same))
                    }
                }
            }

            if !birthDay.isEmpty {
                if !self.isValidBirthday(birthDay) {
                    observer(.failure(BirthDayError.invalid))
                }

                if let existingBirthDay = existing.birthDay {
                    if existingBirthDay == birthDay {
                        observer(.failure(BirthDayError.same))
                    }
                }
            }

            let request = ProfileUpdateRequest(
                nick: nickname,
                phoneNum: phoneNum,
                birthDay: birthDay,
                files: nil
            )

            observer(.success(request))

            return Disposables.create()
        }
    }

}

private extension AccountValidator {

    func isValidNickname(_ nickname: String) -> Bool {
        let nicknameRegex = "^[a-zA-Z0-9가-힣_]{2,20}$"   // 한글, 영어, 숫자, _만 사용 가능, 최소 2글자 ~ 최대 20글자
        let nicknamePredicate = NSPredicate(format: "SELF MATCHES %@", nicknameRegex)
        return nicknamePredicate.evaluate(with: nickname)
    }

    func isValidPhoneNum(_ phoneNum: String) -> Bool {
        let phoneRegex = "^01(?:0|1|[6-9])(?:\\d{3}|\\d{4})\\d{4}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phonePredicate.evaluate(with: phoneNum)
    }

    func isValidBirthday(_ birthday: String) -> Bool {
        let birthdayRegex = #"^\d{4}년 \d{2}월 \d{2}일$"#
        let birthdayPredicate = NSPredicate(format: "SELF MATCHES %@", birthdayRegex)
        return birthdayPredicate.evaluate(with: birthday)
    }

}
