//
//  TabBarController.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/01.
//

import UIKit

final class FakeViewController: UIViewController {}

enum TabBarItem: Int, CaseIterable {
    case todoNewsfeed
    case todoAdd

    var viewController: UIViewController {
        switch self {
        case .todoNewsfeed:
            let viewModel = TodoNewsfeedViewModel()
            let vc = TodoNewsfeedViewController(viewModel)
            vc.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "house.fill"), tag: rawValue)
            return UINavigationController(rootViewController: vc)
        case .todoAdd:
            let vc = FakeViewController()
            vc.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "pencil.line"), tag: rawValue)
            return vc
        }
    }
}

final class TabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
        viewControllers = TabBarItem.allCases.map { $0.viewController }
    }

    func tabBarController(
        _ tabBarController: UITabBarController,
        shouldSelect viewController: UIViewController
    ) -> Bool {
        if viewController is FakeViewController {
            let viewModel = TodoInputViewModel()
            let vc = TodoInputViewController(viewModel)
            let navi = UINavigationController(rootViewController: vc)
            present(navi, animated: true)
            return false
        }

        return true
    }

}
