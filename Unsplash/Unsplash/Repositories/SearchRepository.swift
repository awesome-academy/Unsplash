//
//  SearchRepositories.swift
//  Unsplash
//
//  Created by Nha Pham on 9/3/20.
//  Copyright © 2020 Nha Pham. All rights reserved.
//

import Foundation

final class SearchRepository: BaseRepository {

    func fetchSearchPhotos(request: SearchRequest, completion: @escaping (Result<PhotosResult, Error>) -> Void) {
        super.fetchCollection(request: request, completion: completion)
    }
    
    func fetchCollection(request: SearchRequest, completion: @escaping (Result<PhotoCollectionsResult, Error>) -> Void) {
        super.fetchCollection(request: request, completion: completion)
    }
}
