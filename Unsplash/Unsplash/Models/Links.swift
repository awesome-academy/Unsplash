//
//  Links.swift
//  Unsplash
//
//  Created by Nha Pham on 8/31/20.
//  Copyright © 2020 Nha Pham. All rights reserved.
//

import Foundation
struct Links: Codable {
    var selfLink: String = ""
    var html: String = ""
    var photos: String = ""
    var likes: String = ""
    var portfolio: String = ""
    var download: String = ""
    var downloadLocation: String = ""

    enum CodingKeys: String, CodingKey {
        case selfLink = "self"
        case downloadLocation = "download_location"
    }
}
