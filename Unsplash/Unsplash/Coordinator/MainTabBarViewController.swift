//
//  MainTabBarViewController.swift
//  Unsplash
//
//  Created by Nha Pham on 8/25/20.
//  Copyright © 2020 Nha Pham. All rights reserved.
//

import UIKit
class MainTabBarController: UITabBarController {
    var networkManager = NetworkManager.shared
    
    var alert: UILabel = {
        var textView = UILabel()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .red
        textView.layer.cornerRadius = 25
        textView.layer.masksToBounds = true
        textView.text = "Opps...No Internet connection found"
        textView.textAlignment = .center
        textView.textColor = .white
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        addAlert()
        
        networkManager.monitorNetwork { [weak self] networkStatus in
            switch networkStatus {
            case .online:
                self?.removeAlert()
            case .offline:
                self?.showAlert()
            }
        }
    }
    
    func addAlert() {
        view.addSubview(alert)
        alert.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        alert.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        alert.topAnchor.constraint(equalTo: view.topAnchor, constant: -30).isActive = true
        alert.heightAnchor.constraint(equalToConstant: 50).isActive = true
        alert.isHidden = true
    }
    
    func showAlert() {
        alert.isHidden = false
        UIView.animateKeyframes(withDuration: 0.25,
                                delay: 0,
                                options: .beginFromCurrentState,
                                animations: {
            if self.alert.frame.origin.y < 0 {
                self.alert.frame.origin.y += 135
            }
        }, completion: nil)
    }
    
    func removeAlert() {
        UIView.animateKeyframes(withDuration: 0.25,
                                delay: 0,
                                options: .beginFromCurrentState,
                                animations: {
            if self.alert.frame.origin.y > 0 {
                self.alert.frame.origin.y -= 135
            }
        }, completion: { complete in
            if complete {
                self.alert.isHidden = true
            }
        })
    }
    
    private func setupTabBar() {
        tabBar.tintColor = .black
    }
}
