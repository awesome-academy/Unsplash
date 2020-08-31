//
//  PhotoCollection.swift
//  Unsplash
//
//  Created by Nha Pham on 8/31/20.
//  Copyright © 2020 Nha Pham. All rights reserved.
//

import Foundation

struct PhotoCollection: Codable {
    var id: Int = 0
    let title: String?
    let coverPhoto: Photo?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case coverPhoto = "cover_photo"
    }
}
