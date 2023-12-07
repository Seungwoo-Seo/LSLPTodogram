//
//  SceneDelegate.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/11/20.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private let loginViewModel = LoginViewModel()
    private let todoNewsfeedViewModel = BupNewsfeedViewModel()

    private let todoAddViewModel = TodoInputViewModel()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScene)

//        window?.rootViewController = TodoInputViewController(todoAddViewModel)

        window?.rootViewController = UINavigationController(rootViewController: LoginViewController(loginViewModel))

        window?.makeKeyAndVisible()
    }



}

