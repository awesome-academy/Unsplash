//
//  HeaderCollectionReusableView.swift
//  Unsplash
//
//  Created by Nha Pham on 8/31/20.
//  Copyright © 2020 Nha Pham. All rights reserved.
//

import UIKit

protocol HeaderCollectionViewDelegate: class {
    func collectionViewDidSelectedAt(index: Int)
}

class HeaderCollectionReusableView: UICollectionReusableView {
    // MARK: Outlet
    @IBOutlet private weak var headerCollectionView: UICollectionView!
    @IBOutlet private weak var bottomLabel: UILabel!
    @IBOutlet private weak var topLabel: UILabel!

    static let dentifier = "HeaderCollectionReusableView"
    static func nib() -> UINib {
        return UINib(nibName: "HeaderCollectionReusableView", bundle: nil)
    }

    private var viewModel = HeaderViewModel()

    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }

    weak var delegate: HeaderCollectionViewDelegate?

    private func setupViews() {
        headerCollectionView.register(PhotoCollectionCell.nib(),
                                      forCellWithReuseIdentifier: PhotoCollectionCell.dentifier)
        headerCollectionView.delegate = self
        headerCollectionView.dataSource = self
        backgroundColor = .white
        bottomLabel.text = ""
        topLabel.text = ""
    }
    
    func appendPhotoCollection(photoCollections: [CellViewModel]) {
        viewModel.photoCollectionViewModels.append(contentsOf: photoCollections)
        DispatchQueue.main.async {
            self.headerCollectionView.reloadData()
            self.bottomLabel.text = "Discover"
            self.topLabel.text = "Collections"
        }
    }
}

extension HeaderCollectionReusableView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return viewModel.photoCollectionViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionCell.dentifier,
                                                            for: indexPath) as? PhotoCollectionCell else {
            return UICollectionViewCell()
        }
        let cellViewModel = viewModel.photoCollectionViewModels[indexPath.row]
        cell.updateViews(with: cellViewModel)
        return cell
    }
}

extension HeaderCollectionReusableView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - 60
        let height = collectionView.bounds.height - 10
        return CGSize(width: width, height: height)
    }
}

extension HeaderCollectionReusableView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.collectionViewDidSelectedAt(index: indexPath.row)
    }
}
