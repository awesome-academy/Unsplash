//
//  DetailSearchViewController.swift
//  Unsplash
//
//  Created by Nha Pham on 9/3/20.
//  Copyright © 2020 Nha Pham. All rights reserved.
//

import UIKit

protocol DetailSearchViewControllerDelegate: class {
    func toDetailPhoto(photo: Photo)
    func toDetailPhotoCollection(collection: PhotoCollection)
    func viewDidDisappear(_ viewController: UIViewController)
}

class DetailSearchViewController: UIViewController {
    @IBOutlet private weak var segment: UISegmentedControl!
    @IBOutlet private weak var containView: UIView!
    weak var delegate: DetailSearchViewControllerDelegate?
    var searchTitle = ""
    private var viewModel = DetailViewModel()
    private let photoResultCollectionView = BaseCollectionView(numberOfColumns: 2)
    private let collectionResultCollectionView = BaseCollectionView(numberOfColumns: 1)

    static func instantiate() -> UIViewController {
        let storyBoard = UIStoryboard(name: "DetailSearch", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "DetailSearchViewController")
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        fetchPhotoResult()
        fetchCollectionResult()
        photoResultCollectionView.delegate = self
        collectionResultCollectionView.delegate = self
    }
    
    private func fetchPhotoResult() {
        viewModel.fetchSearchPhoto(query: searchTitle) { [weak self] photoSearchResult in
            switch photoSearchResult {
            case .failure(let error):
                print(error)
            case .success(let result):
                if let result = result {
                    self?.photoResultCollectionView.data = result
                }
            }
        }
    }
    
    private func fetchCollectionResult() {
        viewModel.fetchSearchCollection(query: searchTitle) { [weak self] collectionSearchResult in
            switch collectionSearchResult {
            case .failure(let error):
                print(error)
            case .success(let result):
                if let result = result {
                    self?.collectionResultCollectionView.data = result
                }
            }
        }
    }
    
    private func setupViews() {
        navigationItem.title = "#\(searchTitle)"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .black
        
        photoResultCollectionView.view.frame = containView.bounds
        collectionResultCollectionView.view.frame = containView.bounds
        containView.addSubview(photoResultCollectionView.view)
        containView.addSubview(collectionResultCollectionView.view)
        collectionResultCollectionView.view.isHidden = true

    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
        let backButton = UIBarButtonItem()
        backButton.title = "Search"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.viewDidDisappear(self)
    }
}

// MARK: handle segment
extension DetailSearchViewController {
    @IBAction func didTapSegment(segment: UISegmentedControl) {
        collectionResultCollectionView.view.isHidden = true
        photoResultCollectionView.view.isHidden = true
        if segment.selectedSegmentIndex == 0 {
            photoResultCollectionView.view.isHidden = false
        } else {
            collectionResultCollectionView.view.isHidden = false
        }
    }
}

extension DetailSearchViewController: BaseCollectionViewDelegate {

    func didSelectedAt(index: Int) {
        if segment.selectedSegmentIndex == 0 {
            delegate?.toDetailPhoto(photo: viewModel.photos[index])
        } else {
            delegate?.toDetailPhotoCollection(collection: viewModel.photoCollections[index])
        }
    }

    func loadMore() {
        if segment.selectedSegmentIndex == 0 {
            fetchPhotoResult()
        } else {
            fetchCollectionResult()
        }
    }
    
}
