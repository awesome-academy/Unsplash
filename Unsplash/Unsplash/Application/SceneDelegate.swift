//
//  SceneDelegate.swift
//  Unsplash
//
//  Created by Nha Pham on 8/17/20.
//  Copyright © 2020 Nha Pham. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var tabCoordinator: TabCoordinator?
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
       guard let scene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: scene)
        let rootViewController = RootViewController.instantiate()
        window?.rootViewController = rootViewController
        tabCoordinator = TabCoordinator(rootViewController: rootViewController)
        tabCoordinator?.start()
        window?.makeKeyAndVisible()
    }

}
