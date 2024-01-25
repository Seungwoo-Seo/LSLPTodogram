//
//  MainTabBarViewModel.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/07.
//

import UIKit

final class FakeViewController: UIViewController {}

final class MainTabBarViewModel {
    private let bupNewsfeedViewModel = BupNewsfeedViewModel()
    private let profileViewModel = ProfileViewModel()

    private lazy var bupNewsfeedViewController = {
        let vc = BupNewsfeedViewController(bupNewsfeedViewModel)
        vc.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "house.fill"), tag: 0)
        return vc
    }()
    private let fakeViewController = {
        let vc = FakeViewController()
        vc.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "pencil.line"), tag: 1)
        return vc
    }()
    private lazy var profileViewController = {
        let vc = ProfileViewController(profileViewModel)
        vc.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "person.fill"), tag: 2)
        return vc
    }()

    lazy var viewControllerList = [
        UINavigationController(rootViewController: bupNewsfeedViewController),
        fakeViewController,
        UINavigationController(rootViewController: profileViewController)
    ]

    var bupInputViewController: UIViewController {
//        return UIViewController()
        return BupInputViewController(BupInputViewModel())
    }

}

