//
//  PasswordViewController.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/11/23.
//

import UIKit
import RxCocoa
import RxSwift

final class PasswordViewController: BaseViewController {
    private let mainView = PasswordMainView()

    private let disposeBag = DisposeBag()
    private let viewModel = PasswordViewModel()

    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bind()
    }

    private func bind() {

    }

}
