//
//  HomeCoordinator.swift
//  Unsplash
//
//  Created by Nha Pham on 8/25/20.
//  Copyright © 2020 Nha Pham. All rights reserved.
//

import UIKit
final class HomeCoordinator: Coordinator {
    var chilCoordinstors: [Coordinator] = []
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        guard let homeViewController = HomeViewController.instantiate(Storyboard.Name.Home) as? HomeViewController else {
            return
        }
        homeViewController.delegate = self
        navigationController.pushViewController(homeViewController, animated: false)
    }
}

extension HomeCoordinator: HomeViewControllerDelegate {
    
}
