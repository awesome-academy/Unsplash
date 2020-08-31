//
//  Coordinator.swift
//  Unsplash
//
//  Created by Nha Pham on 8/25/20.
//  Copyright © 2020 Nha Pham. All rights reserved.
//

import UIKit
protocol Coordinator {
    var chilCoordinstors: [Coordinator] { get set}
    var navigationController: UINavigationController { get }
    func start()
}
