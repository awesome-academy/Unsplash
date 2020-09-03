//
//  SearchRequest.swift
//  Unsplash
//
//  Created by Nha Pham on 9/3/20.
//  Copyright © 2020 Nha Pham. All rights reserved.
//

import Foundation
enum SearchType: String {
    case photos
    case collections
}

final class SearchRequest: BaseRequest {
    init(search type: SearchType, query: String, page: Int, elementPerPage: Int, orderBy: Order) {
        let path = "\(URls.API.search)/\(type.rawValue)"
        let parameters = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "\(elementPerPage)"),
            URLQueryItem(name: "order_by", value: "\(orderBy)")
        ]
        super.init(baseUrl: URls.API.baseUrl, path: path, urlComponents: parameters)
    }
    
    init(search type: SearchType, query: String, page: Int, elementPerPage: Int) {
           let path = "\(URls.API.search)/\(type.rawValue)"
           let parameters = [
               URLQueryItem(name: "query", value: query),
               URLQueryItem(name: "page", value: "\(page)"),
               URLQueryItem(name: "per_page", value: "\(elementPerPage)")
           ]
           super.init(baseUrl: URls.API.baseUrl, path: path, urlComponents: parameters)
       }
}
