//
//  EmailViewController.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/11/22.
//

import UIKit

final class EmailViewController: BaseViewController {
    private let mainView = EmailMainView()

    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}
