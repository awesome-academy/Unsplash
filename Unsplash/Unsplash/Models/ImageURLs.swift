//
//  ImageURLs.swift
//  Unsplash
//
//  Created by Nha Pham on 8/31/20.
//  Copyright © 2020 Nha Pham. All rights reserved.
//

import Foundation
struct ImageURLs: Codable {
    let full: URL?
    let raw: URL?
    let regular: URL?
    let small: URL?
    let thumb: URL?
}
