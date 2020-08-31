//
//  BaseRepositories.swift
//  Unsplash
//
//  Created by Nha Pham on 8/31/20.
//  Copyright © 2020 Nha Pham. All rights reserved.
//

import Foundation
class BaseRepository {
    private let api = APIService.shared

    func fetchCollection<T: Codable>(request: BaseRequest, completion: @escaping (Result<T, Error>) -> Void) {
        var urlComponent = URLComponents(string: request.baseUrl)
        urlComponent?.path = request.path
        urlComponent?.queryItems = request.urlComponents
        guard let url = urlComponent?.url else {
            completion(.failure(APIError.unkown))
            return
        }
        let request = URLRequest(url: url)
        api.get(with: request, completion: completion)
    }
}
