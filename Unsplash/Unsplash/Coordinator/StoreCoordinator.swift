//
//  StoreCoordinator.swift
//  Unsplash
//
//  Created by Nha Pham on 8/25/20.
//  Copyright © 2020 Nha Pham. All rights reserved.
//

import UIKit

final class StoreCoordinator: Coordinator {
    var chilCoordinstors: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        guard let storeViewController = StoreViewController.instantiate(Storyboard.Name.Store) as? StoreViewController else {
            return
        }
        storeViewController.delegate = self
        navigationController.pushViewController(storeViewController, animated: false)

    }
}

extension StoreCoordinator: StoreViewControllerDelegate {
    func selectedPhoto(photo: Photo) {
        let detailPhotoCoordinator = DetailPhotoCoordinator(navigationController: navigationController,
                                                            photo: photo)
        detailPhotoCoordinator.parentCoordinator = self
        chilCoordinstors.append(detailPhotoCoordinator)
        detailPhotoCoordinator.start()
    }
}
