//
//  Search.swift
//  Unsplash
//
//  Created by Nha Pham on 9/3/20.
//  Copyright © 2020 Nha Pham. All rights reserved.
//

import Foundation

// MARK: CollectionResult
struct PhotoCollectionsResult: Codable {
    let total: Int?
    let totalPages: Int?
    let results: [PhotoCollection]?

    enum CodingKeys: String, CodingKey {
        case total
        case totalPages = "total_pages"
        case results
    }
}

// MARK: PhotosResult
struct PhotosResult: Codable {
    let total: Int?
    let totalPages: Int?
    let results: [Photo]?

    enum CodingKeys: String, CodingKey {
        case total
        case totalPages = "total_pages"
        case results
    }
}
