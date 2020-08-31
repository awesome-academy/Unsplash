//
//  NetworkManager.swift
//  Unsplash
//
//  Created by Nha Pham on 8/31/20.
//  Copyright © 2020 Nha Pham. All rights reserved.
//

import Foundation
import Network

protocol NetworkDelegate: class {
    func deviceOnline()
}

final class NetworkManager {

    static let shared = NetworkManager()

    let monitor = NWPathMonitor(requiredInterfaceType: .wifi)
    let queue = DispatchQueue(label: "monitor")
    weak var delegate: NetworkDelegate?

    func monitorNetwork(callBack: @escaping((NetworkStatus) -> Void)) {
        monitor.pathUpdateHandler = { [weak self] path in
            if path.status == .satisfied {
                DispatchQueue.main.async {
                    callBack(.online)
                    self?.delegate?.deviceOnline()
                }
            } else {
                DispatchQueue.main.async {
                    callBack(.offline)
                }
            }
        }
        monitor.start(queue: .main)
    }
}
