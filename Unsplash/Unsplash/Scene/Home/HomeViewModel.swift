//
//  HomeViewModel.swift
//  Unsplash
//
//  Created by Nha Pham on 8/31/20.
//  Copyright © 2020 Nha Pham. All rights reserved.
//

import UIKit

final class HomeViewModel {
    var photoRepositories = PhotoRepositories()
    var collectionRepositories = CollectionsRepositories()
    var photoCellViewModel = [CellViewModel]()
    var photos = [Photo]()
    var photoCollections = [PhotoCollection]()
    var photoCollectionCellViewModels = [CellViewModel]()
    var reloadPhoto: (() -> Void)?
    var photoPage = 1

    func fetchPhotos(completion: @escaping ((Result< Void?, Error>) -> Void)) {
        let request = PhotoRequest(order: .lastest, page: photoPage, itemInPerPage: 30)
        photoRepositories.fetchPhotos(request: request) { [weak self] result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let photos):
                self?.photos.append(contentsOf: photos)
                photos.forEach { photo in
                    if let imageUrl = photo.urls?.regular,
                        let imageHeight = photo.height,
                        let imageWidth = photo.width,
                        let color = photo.color {
                    
                    let cellViewModel = CellViewModel(imagePath: imageUrl,
                                                      imageHeight: imageHeight,
                                                      imageWidth: imageWidth,
                                                      backgroundColor: color)
                    self?.photoCellViewModel.append(cellViewModel)
                    }
                }
            }
            completion(.success(nil))
            self?.photoPage += 1
        }
    }

    func fetchCollections(completion: @escaping ((Result<[CellViewModel], Error>) -> Void)) {
        let request = CollectionsRequest()
        collectionRepositories.fetchCollection(request: request) { [weak self] result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let collections):
                self?.photoCollections.append(contentsOf: collections)
                collections.forEach { collection in
                    if let imageUrl = collection.coverPhoto?.urls?.regular,
                        let label = collection.title,
                        let color = collection.coverPhoto?.color {

                        let cellViewModel = CellViewModel(imagePath: imageUrl,
                                                          label: label, backgroundColor: color)
                        self?.photoCollectionCellViewModels.append(cellViewModel)
                    }
                }
            }
            if let photoCollectionViewModel = self?.photoCollectionCellViewModels {
                completion(.success(photoCollectionViewModel))
            }
        }
    }

}
