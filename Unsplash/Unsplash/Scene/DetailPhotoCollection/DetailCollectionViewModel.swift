//
//  DetailCollectionViewModel.swift
//  Unsplash
//
//  Created by Nha Pham on 9/1/20.
//  Copyright © 2020 Nha Pham. All rights reserved.
//

import Foundation
final class DetailCollectionViewModel {
    
    private var page = 1
    private let repo = CollectionsRepositories()
    var photos = [Photo]()
    var photoCellViewModel = [CellViewModel]()
    
    func fetchCollectionPhoto(photoCollection: PhotoCollection, complete: @escaping ((Result<[CellViewModel]?, Error>) -> Void)) {
        let request = CollectionsRequest(id: photoCollection.id, page: page, perPage: 30)
        repo.fetchCollectionPhoto(request: request) { [weak self] result in
            switch result {
            case .failure(let error):
                complete(.failure(error))
            case .success(let photos):
                self?.photos.append(contentsOf: photos)
                photos.forEach { photo in
                    if let imageUrl = photo.urls?.regular,
                        let imageWidth = photo.width,
                        let imageHeight = photo.height,
                        let color = photo.color {
                        
                        let cellViewModel = CellViewModel(imagePath: imageUrl,
                                                          imageHeight: imageHeight,
                                                          imageWidth: imageWidth,
                                                          backgroundColor: color)
                        self?.photoCellViewModel.append(cellViewModel)
                    }
                }
                complete(.success(self?.photoCellViewModel))
                self?.page += 1
            }
        }
    }
}
