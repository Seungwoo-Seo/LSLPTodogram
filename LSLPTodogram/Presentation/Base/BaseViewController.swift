//
//  BaseViewController.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/11/20.
//

import UIKit

class BaseViewController: UIViewController, Base {

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
        navigationController?.navigationBar.tintColor = Color.white
        view.backgroundColor = Color.systemBackground
    }

    func initialHierarchy() {}

    func initialLayout() {}

    func windowReset() {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        sceneDelegate?.window?.rootViewController = LoginViewController()
        sceneDelegate?.window?.makeKeyAndVisible()
    }

}
