//
//  BaseViewController.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/11/20.
//

import UIKit

class BaseViewController: UIViewController, Base {

    override func viewDidLoad() {
        super.viewDidLoad()

        initialAttributes()
        initialHierarchy()
        initialLayout()
    }

    func initialAttributes() {
        view.backgroundColor = Color.systemBackground
    }

    func initialHierarchy() {}

    func initialLayout() {}

}
