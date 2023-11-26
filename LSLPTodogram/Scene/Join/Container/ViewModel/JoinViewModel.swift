//
//  JoinViewModel.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/11/25.
//

import UIKit
import RxCocoa
import RxSwift

final class JoinViewModel: ViewModelType {
    private let disposeBag = DisposeBag()

    private let emailViewModel = EmailViewModel()
    private let passwordViewModel = PasswordViewModel()
    private let userDetailViewModel = UserDetailViewModel()

    private lazy var viewControllers = [
        EmailViewController(viewModel: emailViewModel),
        PasswordViewController(viewModel: passwordViewModel),
        UserDetailViewController(viewModel: userDetailViewModel)
    ]

    struct Input {

    }

    struct Output {
        let scrollToPassword: PublishRelay<Void>
        let scrollToUserDetail: PublishRelay<Void>
        let backScrollToEmail: PublishRelay<Void>
        let backScrollToPassword: PublishRelay<Void>
    }

    func transform(input: Input) -> Output {
        let scrollToPassword = PublishRelay<Void>()
        let scrollToUserDetail = PublishRelay<Void>()
        let backScrollToEmail = PublishRelay<Void>()
        let backScrollToPassword = PublishRelay<Void>()

        // email -> password
        emailViewModel.scrollToNext
            .bind(with: self) { owner, void in
                scrollToPassword.accept(void)
            }
            .disposed(by: disposeBag)

        // password -> userDetail
        passwordViewModel.scrollToNext
            .bind(with: self) { owner, void in
                scrollToUserDetail.accept(void)
            }
            .disposed(by: disposeBag)

        // password -> email
        passwordViewModel.scrollToPrev
            .bind(with: self) { owner, void in
                backScrollToEmail.accept(void)
            }
            .disposed(by: disposeBag)

        let emailAndPassword = Observable
            .combineLatest(
                emailViewModel.email,
                passwordViewModel.password
            )

        userDetailViewModel.join
            .withLatestFrom(emailAndPassword) { npb, ep in
                return (email: ep.0, password: ep.1, nick: npb.nickname, phoneNum: npb.phoneNum, birthDay: npb.birthDay)
            }
            .flatMapLatest {
                return NetworkManager.shared.request(
                    type: JoinDTO.self,
                    api: Router.join(email: $0.email, password: $0.password, nick: $0.nick, phoneNum: $0.phoneNum, birthDay: $0.birthDay)
                )
                .catch { error in
                    print(error.localizedDescription)
                    return Single.never()
                }
            }
            .bind(with: self) { owner, responseDTO in
                print("success")
            }
            .disposed(by: disposeBag)

        // userDetail -> password
        userDetailViewModel.scrollToPrev
            .bind(with: self) { owner, void in
                backScrollToPassword.accept(void)
            }
            .disposed(by: disposeBag)

        return Output(
            scrollToPassword: scrollToPassword,
            scrollToUserDetail: scrollToUserDetail,
            backScrollToEmail: backScrollToEmail,
            backScrollToPassword: backScrollToPassword
        )
    }

}

extension JoinViewModel {

    var numberOfViewControllers: Int {
        return viewControllers.count
    }

    func viewController(at index: Int) -> UIViewController? {
        return viewControllers[index]
    }

}
