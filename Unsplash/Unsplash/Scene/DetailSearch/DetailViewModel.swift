//
//  DetailViewModel.swift
//  Unsplash
//
//  Created by Nha Pham on 9/3/20.
//  Copyright © 2020 Nha Pham. All rights reserved.
//

import Foundation

final class DetailViewModel {
    var searchPhotoResults = [CellViewModel]()
    var searchCollectionResults = [CellViewModel]()
    var searchPhotoPage = 1
    var searchCollectionPage = 1
    var photoCollections = [PhotoCollection]()
    var photos = [Photo]()
    let searchRepo = SearchRepository()
    
    func fetchSearchPhoto(query: String, complete: @escaping (Result<[CellViewModel]?, Error>) -> Void) {
        let request = SearchRequest(search: .photos, query: query, page: searchPhotoPage, elementPerPage: 30, orderBy: .lastest)
        
        searchRepo.fetchSearchPhotos(request: request) { [weak self] result in
            switch result {
            case .failure(let error):
                complete(.failure(error))
            case .success(let photoResults):
                photoResults.results?.forEach { photo in
                    self?.photos.append(photo)
                    if let imageUrl = photo.urls?.regular,
                        let imageWidth = photo.width,
                        let imageHeight = photo.height,
                        let color = photo.color {
                        let cellViewModel = CellViewModel(imagePath: imageUrl,
                                                          imageHeight: imageHeight,
                                                          imageWidth: imageWidth,
                                                          backgroundColor: color)
                        self?.searchPhotoResults.append(cellViewModel)
                    }
                }
                complete(.success(self?.searchPhotoResults))
                self?.searchPhotoPage += 1
            }
        }
    }
    
    func fetchSearchCollection(query: String, complete: @escaping (Result<[CellViewModel]?, Error>) -> Void) {
        let request = SearchRequest(search: .collections, query: query, page: searchCollectionPage, elementPerPage: 30)

        searchRepo.fetchCollection(request: request) { [weak self] result in
            switch result {
            case .failure(let error):
                complete(.failure(error))
            case .success(let collectionResults):
                collectionResults.results?.forEach { collection in
                    self?.photoCollections.append(collection)
                    if let imagePath = collection.coverPhoto?.urls?.regular,
                        let title = collection.title,
                        let color = collection.coverPhoto?.color,
                        let width = collection.coverPhoto?.width,
                        let height = collection.coverPhoto?.height {
                        
                        let cellViewModel = CellViewModel(imagePath: imagePath,
                                                          label: title,
                                                          backgroundColor: color,
                                                          imageHeight: height,
                                                          imageWidth: width)
                        self?.searchCollectionResults.append(cellViewModel)
                    }
                }
                complete(.success(self?.searchCollectionResults))
                self?.searchCollectionPage += 1
            }
        }
    }

}
