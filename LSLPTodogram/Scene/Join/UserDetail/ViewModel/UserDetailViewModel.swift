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

    struct Input {
        let nicknameText: ControlProperty<String?>
        let phoneNubText: ControlProperty<String?>
        let birthDayText: ControlProperty<String?>
        let joinButtonTapped: ControlEvent<Void>
    }

    struct Output {
        let nicknameIsEmpty: PublishRelay<Bool>
    }

    func transform(input: Input) -> Output {
        let nicknameIsEmpty = PublishRelay<Bool>()

        let combineTexts = Observable
            .combineLatest(
                input.nicknameText.orEmpty,
                input.phoneNubText.orEmpty,
                input.birthDayText.orEmpty
            )

        let userDetailTexts = input.joinButtonTapped
            .withLatestFrom(combineTexts)
            .share()

        userDetailTexts
            .filter { $0.0.isEmpty }
            .debug()
            .bind(with: self) { owner, _ in
                nicknameIsEmpty.accept(true)
            }
            .disposed(by: disposeBag)

        userDetailTexts
            .filter { !$0.0.isEmpty }
            // TODO: 정규식 추가
            .flatMapLatest { texts in
                return NetworkManager.shared.request(
                    type: JoinDTO.self,
                    api: Router.join(email: texts.0, password: texts.1, nick: texts.2, phoneNum: nil, birthDay: nil)
                )
            }
            .bind(with: self) { owner, response in
                // NOTE: 여길 할게 없긴할거 같긴해
            }
            .disposed(by: disposeBag)

        return Output(
            nicknameIsEmpty: nicknameIsEmpty
        )
    }

}
