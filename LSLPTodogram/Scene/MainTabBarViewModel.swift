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

    lazy var viewControllerList = [
        bupNewsfeedViewController,
        fakeViewController
    ]

    var todoInputViewController: UIViewController {
        return TodoInputViewController(TodoInputViewModel())
    }

}

