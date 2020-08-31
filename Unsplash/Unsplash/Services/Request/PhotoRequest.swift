//
//  PhotoRequest.swift
//  Unsplash
//
//  Created by Nha Pham on 8/31/20.
//  Copyright © 2020 Nha Pham. All rights reserved.
//

import Foundation
final class PhotoRequest: BaseRequest {

    init(order: Order, page: Int, itemInPerPage: Int) {
        let parameters = [
            URLQueryItem(name: "order_by", value: order.rawValue),
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "\(itemInPerPage)")
        ]
        
        super.init(baseUrl: URls.API.baseUrl, path: URls.API.photos, urlComponents: parameters)
    }

    init(id: String) {
        super.init(baseUrl: URls.API.baseUrl, path: "\(URls.API.photos)/\(id)", urlComponents: [])
     }
}
