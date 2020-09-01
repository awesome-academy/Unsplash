//
//  PhotoCollectionCell.swift
//  Unsplash
//
//  Created by Nha Pham on 8/31/20.
//  Copyright © 2020 Nha Pham. All rights reserved.
//

import UIKit
import Kingfisher

class PhotoCollectionCell: UICollectionViewCell {
    @IBOutlet private weak var photoCellImageView: UIImageView!
    @IBOutlet private weak var photoCellBackgourdColor: UIView!
    @IBOutlet private weak var collectionTitle: UILabel!

    static let dentifier = "PhotoCollectionCell"

    static func nib() -> UINib {
        return UINib(nibName: "PhotoCollectionCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }

    private func setupViews() {
        photoCellImageView.layer.cornerRadius = 15
        photoCellBackgourdColor.layer.cornerRadius = 15
    }

    private func setupImageWithoutLabel() {
        collectionTitle.isHidden = true
        photoCellBackgourdColor.isHidden = true
    }

    func updateViews(imagePath: URL) {
        photoCellImageView.kf.setImage(with: imagePath)
    }

    func updateViews(with cellViewModel: CellViewModel) {
        photoCellImageView.kf.setImage(with: cellViewModel.imagePath)
        if let colorCode = cellViewModel.backgroundColor {
            photoCellImageView.backgroundColor = UIColor.init(hex: colorCode)
        }
        guard let label = cellViewModel.label else {
            setupImageWithoutLabel()
            return
        }
        collectionTitle.text = label
    }
}
