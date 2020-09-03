//
//  DetailPhotoCollectionViewController.swift
//  Unsplash
//
//  Created by Nha Pham on 9/1/20.
//  Copyright © 2020 Nha Pham. All rights reserved.
//

import UIKit
protocol DetailCollectionDelegate: class {
    func viewDidDisappear(_ viewController: UIViewController)
    func selectedImage(photo: Photo)
}

class DetailPhotoCollectionVC: UIViewController {
    @IBOutlet private weak var containerView: UIView!
    private let photoCollectionView = BaseCollectionView(numberOfColumns: 2)
    var photoCollection: PhotoCollection!
    private var viewModel = DetailCollectionViewModel()
    weak var delegate: DetailCollectionDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        fetchPhotoCollection()
    }
    
    private func setupViews() {
        containerView.addSubview(photoCollectionView.view)
        photoCollectionView.didMove(toParent: self)
        photoCollectionView.view.frame = containerView.bounds
        photoCollectionView.delegate = self
        
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .black
        navigationItem.title = photoCollection.title ?? ""
    }
    
    private func fetchPhotoCollection() {
        viewModel.fetchCollectionPhoto(photoCollection: photoCollection) { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
                return
            case .success(let photos):
                guard let photos = photos else {
                    return
                }
                self?.photoCollectionView.data = photos
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.viewDidDisappear(self)
    }
}

extension DetailPhotoCollectionVC: BaseCollectionViewDelegate {
    func didSelectedAt(index: Int) {
        delegate?.selectedImage(photo: viewModel.photos[index])
    }

    func loadMore() {
        self.fetchPhotoCollection()
    }
}
