//
//  CollectionsRepositories.swift
//  Unsplash
//
//  Created by Nha Pham on 8/31/20.
//  Copyright © 2020 Nha Pham. All rights reserved.
//

import Foundation

class CollectionsRepositories: BaseRepository {

    func fetchCollection(request: CollectionsRequest, completion: @escaping (Result<[PhotoCollection], Error>) -> Void) {
        super.fetchCollection(request: request, completion: completion)
    }
    
    func fetchCollectionPhoto(request: CollectionsRequest, completion: @escaping (Result<[Photo], Error>) -> Void) {
        super.fetchCollection(request: request, completion: completion)
    }
}
