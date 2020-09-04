//
//  SplashViewController.swift
//  Unsplash
//
//  Created by Nha Pham on 9/4/20.
//  Copyright © 2020 Nha Pham. All rights reserved.
//

import UIKit

protocol SplashViewControllerDelegate: class {
    func startMainTab()
}
class SplashViewController: UIViewController {
    weak var delegate: SplashViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.delegate?.startMainTab()
        }
    }
}
