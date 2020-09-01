//
//  CollectionsRequest.swift
//  Unsplash
//
//  Created by Nha Pham on 8/31/20.
//  Copyright © 2020 Nha Pham. All rights reserved.
//

import Foundation

final class CollectionsRequest: BaseRequest {
    
    init() {
        super.init(baseUrl: URls.API.baseUrl, path: URls.API.collections, urlComponents: [])
    }

    // get photo in collection
    init(id: Int, page: Int, perPage: Int) {
        let parameters = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "\(perPage)")
        ]
        let collection = URls.API.collections
        let id = "/\(id)"
        let photo = URls.API.photos
        let path = collection + id + photo
        super.init(baseUrl: URls.API.baseUrl, path: path, urlComponents: parameters)
    }
}
