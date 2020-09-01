//
//  DetailPhotoCoordinator.swift
//  Unsplash
//
//  Created by Nha Pham on 9/1/20.
//  Copyright © 2020 Nha Pham. All rights reserved.
//

import UIKit
import imglyKit

final class DetailPhotoCoordinator: Coordinator {
    var chilCoordinstors: [Coordinator] = []
    var navigationController: UINavigationController
    var photo: Photo
    var parentCoordinator: Coordinator?
    init(navigationController: UINavigationController, photo: Photo) {
        self.navigationController = navigationController
        self.photo = photo
    }
    
    func start() {
        guard let detailPhotoViewController = DetailPhotoViewController.instantiate(Storyboard.Name.DetailPhoto) as? DetailPhotoViewController else {
            return
        }
        detailPhotoViewController.delegate = self
        detailPhotoViewController.photo = photo
        navigationController.pushViewController(detailPhotoViewController, animated: true)
    }
}

extension DetailPhotoCoordinator: DetailPhotoDelegate {
    func startEditPhoto(editorCompletionBlock: @escaping (IMGLYEditorResult, UIImage?) -> Void, imageView: UIImageView) {
         let editPhotoCoordinator = EditPhotoCoordinator(navigationController: navigationController,
                                                         editorCompletionBlock: editorCompletionBlock)
        editPhotoCoordinator.imageView = imageView
        chilCoordinstors.append(editPhotoCoordinator)
        editPhotoCoordinator.start()
    }
    
    func showAlertWith(title: String, message: String) {
        let alertAction = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionDone = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
        if self?.navigationController.topViewController as? IMGLYMainEditorViewController != nil {
                self?.navigationController.popViewController(animated: true)
            }
        }
        alertAction.addAction(actionDone)
        navigationController.present(alertAction, animated: true, completion: nil)
    }
    
    func viewDidDisapear(_ viewController: UIViewController) {
        if !navigationController.viewControllers.contains(viewController) {
            parentCoordinator?.childDidFinish(self)
        }
    }
}
