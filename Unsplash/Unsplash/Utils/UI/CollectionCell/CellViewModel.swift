//
//  CellViewModel.swift
//  Unsplash
//
//  Created by Nha Pham on 8/31/20.
//  Copyright © 2020 Nha Pham. All rights reserved.
//

import UIKit

struct CellViewModel {
    var imagePath: URL
    var label: String? = ""
    var imageHeight: Int? = 0
    var imageWidth: Int? = 0
    var backgroundColor: String? = ""

    init(imagePath: URL, label: String, backgroundColor: String) {
        self.imagePath = imagePath
        self.label = label
        self.backgroundColor = backgroundColor
    }

    init(imagePath: URL, label: String, backgroundColor: String, imageHeight: Int, imageWidth: Int) {
        self.imagePath = imagePath
        self.label = label
        self.backgroundColor = backgroundColor
        self.imageHeight = imageHeight
        self.imageWidth = imageWidth
    }

    init(imagePath: URL, imageHeight: Int, imageWidth: Int, backgroundColor: String) {
        self.imagePath = imagePath
        self.imageHeight = imageHeight
        self.imageWidth = imageWidth
        self.backgroundColor = backgroundColor
    }
}
