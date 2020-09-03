//
//  EditPhotoCoordinator.swift
//  Unsplash
//
//  Created by Nha Pham on 9/3/20.
//  Copyright © 2020 Nha Pham. All rights reserved.
//

import UIKit
import imglyKit

final class EditPhotoCoordinator: Coordinator {
    var chilCoordinstors: [Coordinator] = []
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    var imageView: UIImageView?
    var editorCompletionBlock: IMGLYEditorCompletionBlock?

    init(navigationController: UINavigationController, editorCompletionBlock: @escaping IMGLYEditorCompletionBlock) {
        self.navigationController = navigationController
        self.editorCompletionBlock = editorCompletionBlock
    }

    func start() {
       let editorViewController = IMGLYMainEditorViewController()
        editorViewController.highResolutionImage = imageView?.image
        editorViewController.initialFilterType = .none
        editorViewController.initialFilterIntensity = 0.5
        editorViewController.completionBlock = editorCompletionBlock
        navigationController.pushViewController(editorViewController, animated: true)
    }
}
