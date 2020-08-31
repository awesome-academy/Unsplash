//
//  HomeViewController.swift
//  Unsplash
//
//  Created by Nha Pham on 8/25/20.
//  Copyright © 2020 Nha Pham. All rights reserved.
//

import UIKit

protocol HomeViewControllerDelegate: class {
}

final class HomeViewController: UIViewController {
    weak var delegate: HomeViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    private func setupViews() {
        navigationItem.title = "Unsplash"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .black
    }
}
