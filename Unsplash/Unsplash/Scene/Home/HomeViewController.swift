//
//  HomeViewController.swift
//  Unsplash
//
//  Created by Nha Pham on 8/17/20.
//  Copyright © 2020 Nha Pham. All rights reserved.
//

import UIKit
import Network
protocol HomeViewControllerDelegate: class {
    func getPhotoInCollection(_ photoCollection: PhotoCollection)
}

final class HomeViewController: UIViewController {
    @IBOutlet private weak var homeCollectionView: UICollectionView!
    var isfetching = false
    var isLoadedData = false
    var isHomeAppear = false
    var networkManager = NetworkManager.shared
    var viewModel = HomeViewModel()
    var headerView: HeaderCollectionReusableView?
    weak var delegate: HomeViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupCollectionView()
        setupNetwork()
        tabBarController?.delegate = self
    }

    private func setupNetwork() {
        networkManager.delegate = self
    }

    private func fetchData() {
        viewModel.fetchCollections { [weak self] result in
            switch result {
            case .success(let cellViewModels):
                self?.headerView?.appendPhotoCollection(photoCollections: cellViewModels)
            case .failure(let error):
                print("error fetch collection \(error)")
            }
        }

        viewModel.fetchPhotos(completion: { [weak self] result in
            switch result {
            case .failure(let error):
                print("error fetch photo data \(error)")
            case .success:
                DispatchQueue.main.async {
                    self?.homeCollectionView.reloadData()
                }
            }
            
        })

        isLoadedData = true
    }

    private func setupViews() {
        navigationItem.title = "Unsplash"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .black
        let searchBtn = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(startSearch))
        navigationItem.rightBarButtonItem = searchBtn
    }

    private func setupCollectionView() {
        let customLayout = CustomLayout()
        customLayout.delegate = self
        customLayout.headerDelegate = self
        homeCollectionView.collectionViewLayout = customLayout
        homeCollectionView.dataSource = self
        homeCollectionView.delegate = self
        homeCollectionView.prefetchDataSource = self
        homeCollectionView.register(PhotoCollectionCell.nib(),
                                    forCellWithReuseIdentifier: PhotoCollectionCell.dentifier)
        homeCollectionView.register(HeaderCollectionReusableView.nib(),
                                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                    withReuseIdentifier: HeaderCollectionReusableView.dentifier)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isHomeAppear = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isHomeAppear = false
    }

    @objc func startSearch() {
        // start search
    }
}

// MARK: collectionview
extension HomeViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        let numberOfItem = viewModel.photoCellViewModel.count
        return numberOfItem
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionCell.dentifier, for: indexPath) as? PhotoCollectionCell else {
            return UICollectionViewCell()
        }
        let cellViewModel = viewModel.photoCellViewModel[indexPath.row]
        cell.updateViews(with: cellViewModel)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        let dentifier = HeaderCollectionReusableView.dentifier
        headerView = collectionView.dequeueReusableSupplementaryView( ofKind: UICollectionView.elementKindSectionHeader,
                                                                      withReuseIdentifier: dentifier,
                                                                      for: indexPath) as? HeaderCollectionReusableView
        guard let headerView = headerView else {
            return UICollectionReusableView()
        }

        headerView.delegate = self
        return headerView
    }
}

// MARK: CollectionView Custom Layout
extension HomeViewController: CustomLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, sizeOfPhotoAtIndexPath indexPath: IndexPath) -> CGSize {
        let cellViewModel = viewModel.photoCellViewModel[indexPath.row]
        let width = cellViewModel.imageWidth ?? 0
        let height = cellViewModel.imageHeight ?? 0
        return CGSize(width: width, height: height)
    }
}

extension HomeViewController: CustomLayoutHeaderDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = collectionView.bounds.width
        let height = collectionView.bounds.height / 2.5
        return CGSize(width: width, height: height)
    }
}
// MARK: Load More
extension HomeViewController: UICollectionViewDataSourcePrefetching {

    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if indexPath.row >= viewModel.photoCellViewModel.count - 3 && !isfetching {
                isfetching = true
                self.fetchingData()
                break
            }
        }
    }

    private func fetchingData() {
        viewModel.fetchPhotos(completion: { [weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self?.homeCollectionView.reloadData()
                }
            case .failure(let error):
                print("error fetch photo data \(error)")
            }
        })
        isfetching = false
    }
}

// MARK: Network Delegate
extension HomeViewController: NetworkDelegate {
    func deviceOnline() {
        if !isLoadedData {
            fetchData()
            isLoadedData = true
        }
    }
}

// MARK: header did sellected
extension HomeViewController: HeaderCollectionViewDelegate {
    func collectionViewDidSelectedAt(index: Int) {
        let collectionSellected = viewModel.photoCollections[index]
        delegate?.getPhotoInCollection(collectionSellected)
    }
}

// MARK: get a photo
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // go photo detail
    }
}

extension HomeViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let navigationController = viewController as? UINavigationController else {
            return
        }

        if navigationController.viewControllers.first === self && isHomeAppear {
            if let headerView = headerView {
                homeCollectionView.scrollRectToVisible(headerView.frame, animated: true)
            } else {
                homeCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
            }
        }
    }
}
