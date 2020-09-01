//
//  BaseCollectionView.swift
//  Unsplash
//
//  Created by Nha Pham on 9/1/20.
//  Copyright © 2020 Nha Pham. All rights reserved.
//

import UIKit

protocol BaseCollectionViewDelegate: class {
    func didSelectedAt(index: Int)
}

extension BaseCollectionViewDelegate {
    func loadMore() {}
}

class BaseCollectionView: UIViewController {
    @IBOutlet weak var baseCollectionView: UICollectionView!
    var data = [CellViewModel]() {
        didSet {
            baseCollectionView.reloadData()
        }
    }
    var isFetching = false
    var numberOfColumns = 2
    let customLayout = CustomLayout()
    weak var delegate: BaseCollectionViewDelegate?
    var currentDataCount = 0
    var newDataCount = 0

    init(numberOfColumns: Int) {
        super.init(nibName: "BaseCollectionView", bundle: nil)
        self.numberOfColumns = numberOfColumns
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    func setupCollectionView() {
        customLayout.delegate = self
        customLayout.numberOfColumns = numberOfColumns
        baseCollectionView.collectionViewLayout = customLayout
        baseCollectionView.dataSource = self
        baseCollectionView.delegate = self
        baseCollectionView.prefetchDataSource = self
        baseCollectionView.register(PhotoCollectionCell.nib(),
                                    forCellWithReuseIdentifier: PhotoCollectionCell.dentifier)
    }
}

extension BaseCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectedAt(index: indexPath.row)
    }
}

extension BaseCollectionView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        newDataCount = data.count
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionCell.dentifier,
                                                            for: indexPath) as? PhotoCollectionCell else {
            return UICollectionViewCell()
        }
        let dataCell = data[indexPath.row]
        cell.updateViews(with: dataCell)
        return cell
    }
}
extension BaseCollectionView: CustomLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, sizeOfPhotoAtIndexPath indexPath: IndexPath) -> CGSize {
        let width = data[indexPath.row].imageWidth ?? 0
        let height = data[indexPath.row].imageHeight ?? 0
        return CGSize(width: width, height: height)
    }
}

extension BaseCollectionView: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            // if no more new data no more fetch data
            if indexPath.row >= data.count - 3 && currentDataCount != newDataCount {
                currentDataCount = data.count
                delegate?.loadMore()
                break
            }
        }
    }
}
