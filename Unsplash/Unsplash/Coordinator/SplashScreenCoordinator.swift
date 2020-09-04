//
//  SplashScreenCoordinator.swift
//  Unsplash
//
//  Created by Nha Pham on 9/4/20.
//  Copyright © 2020 Nha Pham. All rights reserved.
//

import UIKit

final class SplashScreenCoordinator: Coordinator {
    var chilCoordinstors: [Coordinator] = []
    var navigationController: UINavigationController
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        guard let splashViewController = SplashViewController.instantiate(Storyboard.Name.Splash) as? SplashViewController else {
            return
        }
        splashViewController.delegate = self
        navigationController.pushViewController(splashViewController, animated: true)
    }
}

extension SplashScreenCoordinator: SplashViewControllerDelegate {
    func startMainTab() {
        let rootViewController = RootViewController.instantiate()
        let tabCoordinator = TabCoordinator(rootViewController: rootViewController)
        chilCoordinstors.append(tabCoordinator)
        tabCoordinator.start()
        rootViewController.modalPresentationStyle = .fullScreen
        navigationController.present(rootViewController, animated: true, completion: nil)
    }
    
}
