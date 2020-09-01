//
//  Coordinator.swift
//  Unsplash
//
//  Created by Nha Pham on 8/25/20.
//  Copyright © 2020 Nha Pham. All rights reserved.
//

import UIKit
protocol Coordinator: class {
    var chilCoordinstors: [Coordinator] { get set}
    var navigationController: UINavigationController { get }
    func start()
    func childDidFinish(_ child: Coordinator?)
}

extension Coordinator {
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordintor) in chilCoordinstors.enumerated() {
            if coordintor === child {
                chilCoordinstors.remove(at: index)
                break
            }
        }
    }
}
