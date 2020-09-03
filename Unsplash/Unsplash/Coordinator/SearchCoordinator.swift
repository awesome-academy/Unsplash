//
//  SearchCoordinator.swift
//  Unsplash
//
//  Created by Nha Pham on 9/3/20.
//  Copyright © 2020 Nha Pham. All rights reserved.
//

import UIKit

final class SearchCoordinator: Coordinator {
    var chilCoordinstors: [Coordinator] = []
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        guard let searchViewController = SearchViewController.instantiate(Storyboard.Name.Search) as? SearchViewController else {
            return
        }
        searchViewController.delegate = self
        navigationController.pushViewController(searchViewController, animated: true)
    }
}

extension SearchCoordinator: SearchViewControllerDelegate {
    func viewDidDisappear(viewController: UIViewController) {
        if !navigationController.viewControllers.contains(viewController) {
            parentCoordinator?.childDidFinish(self)
        }
    }
    
    func searchAction(searchKey: String) {
    }
}
