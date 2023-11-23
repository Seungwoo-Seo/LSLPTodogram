//
//  UserDetailViewController.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/11/23.
//

import UIKit

final class UserDetailViewController: BaseViewController {
    private let mainView = UserDetailMainView()

    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}
