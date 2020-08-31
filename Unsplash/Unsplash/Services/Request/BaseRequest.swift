//
//  BaseRequest.swift
//  Unsplash
//
//  Created by Nha Pham on 8/31/20.
//  Copyright © 2020 Nha Pham. All rights reserved.
//

import Foundation

class BaseRequest {
    var baseUrl = ""
    var path = ""
    var urlComponents = [
         URLQueryItem(name: "client_id", value: APIKey.apiKey)
    ]

    init(baseUrl: String, path: String, urlComponents: [URLQueryItem]) {
        self.baseUrl = baseUrl
        self.path = path
        self.urlComponents.append(contentsOf: urlComponents)
    }
}
