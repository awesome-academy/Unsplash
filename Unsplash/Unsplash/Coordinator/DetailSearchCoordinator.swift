//
//  DetailSearchCoordinator.swift
//  Unsplash
//
//  Created by Nha Pham on 9/3/20.
//  Copyright © 2020 Nha Pham. All rights reserved.
//

import UIKit

final class DetailSearchCoordinator: Coordinator {
    var chilCoordinstors: [Coordinator] = []
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    var searchKey: String = ""
    init(navigationController: UINavigationController, searchKey: String) {
        self.navigationController = navigationController
        self.searchKey = searchKey
    }
    
    func start() {
        guard let detailSearchViewController = DetailSearchViewController.instantiate() as? DetailSearchViewController else {
            return
        }
        detailSearchViewController.delegate = self
        detailSearchViewController.searchTitle = searchKey
        navigationController.pushViewController(detailSearchViewController, animated: true)
    }
    
}

extension DetailSearchCoordinator: DetailSearchViewControllerDelegate {
    func viewDidDisappear(_ viewController: UIViewController) {
        if !navigationController.viewControllers.contains(viewController) {
            parentCoordinator?.childDidFinish(self)
        }
    }
    
    func toDetailPhotoCollection(collection: PhotoCollection) {
        let detailPhotoCoordinator = DetailPhotoCollectionCoordinator(navigationController: navigationController, photoCollection: collection)
        chilCoordinstors.append(detailPhotoCoordinator)
        detailPhotoCoordinator.start()
    }
    
    func toDetailPhoto(photo: Photo) {
        let detailPhotoCoordinator = DetailPhotoCoordinator(navigationController: navigationController, photo: photo)
        chilCoordinstors.append(detailPhotoCoordinator)
        detailPhotoCoordinator.start()
    }
}
