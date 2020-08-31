//
//  APIService.swift
//  Unsplash
//
//  Created by Nha Pham on 8/31/20.
//  Copyright © 2020 Nha Pham. All rights reserved.
//

import Foundation
enum APIError: Error {
    case unkown, badResponse, jsonDecoder
}

struct APIService {
    static let shared = APIService()

    func get<T: Codable>(with request: URLRequest, completion: @escaping (Result<T, Error>) -> Void) {
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in

            if let error = error {
                completion(.failure(error))
                return
            }

            guard let response = response as? HTTPURLResponse, 200..<300 ~= response.statusCode else {
               completion(.failure(APIError.badResponse))
                return
            }

            guard let value = try? JSONDecoder().decode(T.self, from: data!) else {
                completion(.failure(APIError.jsonDecoder))
                return
            }

            DispatchQueue.main.async {
                completion(.success(value))
            }
        }
        task.resume()
    }
}
