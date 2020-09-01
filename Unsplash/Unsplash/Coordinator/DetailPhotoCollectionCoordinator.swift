//
//  DetailPhotoCollectionCoordinator.swift
//  Unsplash
//
//  Created by Nha Pham on 9/1/20.
//  Copyright © 2020 Nha Pham. All rights reserved.
//

import UIKit
final class DetailPhotoCollectionCoordinator: Coordinator {
    var chilCoordinstors: [Coordinator] = []
    var navigationController: UINavigationController
    var photoCollection: PhotoCollection!
    var parentCoordinator: Coordinator?

    init(navigationController: UINavigationController, photoCollection: PhotoCollection) {
        self.navigationController = navigationController
        self.photoCollection = photoCollection
    }

    func start() {
        guard let detailPhotoCollectionVC = DetailPhotoCollectionVC.instantiate(Storyboard.Name.DetailCollectionPhoto) as? DetailPhotoCollectionVC else {
            return
        }
        detailPhotoCollectionVC.delegate = self
        navigationController.pushViewController(detailPhotoCollectionVC, animated: true)
        detailPhotoCollectionVC.photoCollection = photoCollection
    }
}

extension DetailPhotoCollectionCoordinator: DetailCollectionDelegate {
    func viewDidDisappear() {
        parentCoordinator?.childDidFinish(self)
    }
}
