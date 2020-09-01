//
//  PhotoRepositories.swift
//  Unsplash
//
//  Created by Nha Pham on 8/31/20.
//  Copyright © 2020 Nha Pham. All rights reserved.
//

import Foundation

class PhotoRepositories: BaseRepository {

    func fetchPhotos(request: PhotoRequest, completion: @escaping (Result<[Photo], Error>) -> Void) {
        super.fetchCollection(request: request, completion: completion)
    }

    func fetchAPhoto(request: PhotoRequest, completion: @escaping (Result<Photo, Error>) -> Void) {
        super.fetchCollection(request: request, completion: completion)
    }
}
