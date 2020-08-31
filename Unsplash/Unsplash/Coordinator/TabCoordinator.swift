//
//  TabCoordinator.swift
//  Unsplash
//
//  Created by Nha Pham on 8/25/20.
//  Copyright © 2020 Nha Pham. All rights reserved.
//
import UIKit

final class TabCoordinator: Coordinator {
    var chilCoordinstors: [Coordinator] = []
    var navigationController: UINavigationController
    private var rootViewController: UIViewController!

    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
        navigationController = UINavigationController()
    }

    func start() {
        guard let tabBarController = MainTabBarController.instantiate(Storyboard.Name.Tabbar) as? MainTabBarController else {
            return
        }

        let homeCoordinator = HomeCoordinator(navigationController: UINavigationController())
        chilCoordinstors.append(homeCoordinator)
        homeCoordinator.start()

        let storeCoordinator = StoreCoordinator(navigationController: UINavigationController())
        chilCoordinstors.append(storeCoordinator)
        storeCoordinator.start()

        tabBarController.viewControllers = [
            homeCoordinator.navigationController,
            storeCoordinator.navigationController
        ]

        tabBarController.display(on: rootViewController)
    }
}
