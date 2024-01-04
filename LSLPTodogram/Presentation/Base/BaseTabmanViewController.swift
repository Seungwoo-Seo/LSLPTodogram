//
//  BaseTabmanViewController.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/11/26.
//

import UIKit
import Tabman

class BaseTabmanViewController: TabmanViewController, Base {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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
