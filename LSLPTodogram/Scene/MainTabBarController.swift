//
//  TabBarController.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/01.
//

import UIKit

final class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    private let viewModel = MainTabBarViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
        viewControllers = viewModel.viewControllerList
    }

    func tabBarController(
        _ tabBarController: UITabBarController,
        shouldSelect viewController: UIViewController
    ) -> Bool {
        if viewController is FakeViewController {
            let vc = viewModel.todoInputViewController
            let navi = UINavigationController(rootViewController: vc)
            present(navi, animated: true)
            return false
        }

        return true
    }

}
