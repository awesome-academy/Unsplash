//
//  UIViewController+.swift
//  Unsplash
//
//  Created by Nha Pham on 8/25/20.
//  Copyright © 2020 Nha Pham. All rights reserved.
//

import UIKit

extension UIViewController {

    func display(on parent: UIViewController) {
        if let childViewController = parent.children.first {
            childViewController.hide()
        }
        parent.addChild(self)
        parent.view.addSubview(view)
        view.frame = parent.view.frame
        didMove(toParent: parent)
    }

    func hide() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }

    static var storyboardIdentifier: String {
        return String(describing: self)
    }

    static func instantiate(_ storybardName: String = Storyboard.Name.Root) -> UIViewController {
        let storyBoard = UIStoryboard(name: storybardName, bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: storyboardIdentifier)
        return viewController
    }

}
