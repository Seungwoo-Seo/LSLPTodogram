//
//  SceneDelegate.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/11/20.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScene)

        if let _ = KeychainManager.read(key: KeychainKey.token.rawValue) {
            window?.rootViewController = MainTabBarController()
        } else {
            window?.rootViewController = UINavigationController(rootViewController: LoginViewController())
        }

        window?.makeKeyAndVisible()
    }



}

