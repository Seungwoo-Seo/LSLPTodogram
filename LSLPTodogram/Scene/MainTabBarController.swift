//
//  TabBarController.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/01.
//

import UIKit

fileprivate enum MainTabBarItem: Int, CaseIterable {
    case todoNewsfeed
    case todoAdd

    var viewController: UIViewController {
        switch self {
        case .todoNewsfeed:
            let viewModel = BupNewsfeedViewModel()
            let vc = BupNewsfeedViewController(viewModel)
            vc.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "house.fill"), tag: rawValue)
            return UINavigationController(rootViewController: vc)
        case .todoAdd:
            let vc = FakeViewController()
            vc.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "pencil.line"), tag: rawValue)
            return vc
        }
    }
}

final class MainTabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
        viewControllers = MainTabBarItem.allCases.map { $0.viewController }
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

fileprivate final class FakeViewController: UIViewController {}
