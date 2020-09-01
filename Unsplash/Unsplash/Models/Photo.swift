//
//  Photo.swift
//  Unsplash
//
//  Created by Nha Pham on 8/31/20.
//  Copyright © 2020 Nha Pham. All rights reserved.
//

import Foundation

struct Photo: Codable {
    var id: String = ""
    var color: String = "#ffffff"
    var width: Int = 0
    var height: Int = 0
    let urls: ImageURLs?
    let collectionsItBelongs: [PhotoCollection]?
    let links: Links?

    enum CodingKeys: String, CodingKey {
        case id
        case color
        case width
        case height
        case urls
        case collectionsItBelongs = "current_user_collections"
        case links
    }
}
