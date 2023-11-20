//
//  LoginViewController.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/11/20.
//

import UIKit
import RxCocoa
import RxSwift

final class LoginViewController: BaseViewController {
    let mainView = LoginMainView()
    let viewModel = LoginViewModel()

    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
