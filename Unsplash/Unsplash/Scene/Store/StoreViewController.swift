//
//  StoreViewController.swift
//  Unsplash
//
//  Created by Nha Pham on 8/25/20.
//  Copyright © 2020 Nha Pham. All rights reserved.
//

import UIKit
import RealmSwift

protocol StoreViewControllerDelegate: class {
    func selectedPhoto(photo: Photo)
}

final class StoreViewController: UIViewController {
    @IBOutlet private weak var containerView: UIView!
    private var networkManager = NetworkManager.shared
    weak var delegate: StoreViewControllerDelegate?
    private let realmManager = RealmManager.shared
    private var storePhoto: Results<Store>!
    private var storeCollectionView = BaseCollectionView(numberOfColumns: 2)
    private var viewModel = StoreViewModel()
    private var isFetchedData = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        networkManager.delegate = self
        storeCollectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    private func fetchData() {
        viewModel.cellViewModels.removeAll()
        viewModel.photos.removeAll()
        storePhoto = realmManager.fetchData()
        var photoIds = [String]()
        
        storePhoto.reversed().forEach { store in
            photoIds.append(store.imageId)
        }
        
        viewModel.fetchPhoto(photoIds: photoIds) { [weak self] cellViewModel in
            guard let cellViewModel = cellViewModel else {
                return
            }

            if self?.viewModel.cellViewModels.count != self?.storeCollectionView.data.count {
                self?.storeCollectionView.data = cellViewModel
                self?.isFetchedData = true
            }

        }
    }
    
    private func setupViews() {
        navigationItem.title = "Store"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = .white

        storeCollectionView.view.frame = containerView.bounds
        containerView.addSubview(storeCollectionView.view)
        addChild(storeCollectionView)
        
    }
}

extension StoreViewController: BaseCollectionViewDelegate {
    func didSelectedAt(index: Int) {
        delegate?.selectedPhoto(photo: viewModel.photos[index])
    }
}

extension StoreViewController: NetworkDelegate {
    func deviceOnline() {
        if !isFetchedData {
            fetchData()
        }
    }
}
