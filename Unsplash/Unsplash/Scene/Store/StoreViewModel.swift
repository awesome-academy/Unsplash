//
//  StoreViewModel.swift
//  Unsplash
//
//  Created by Nha Pham on 9/3/20.
//  Copyright © 2020 Nha Pham. All rights reserved.
//

import Foundation

final class StoreViewModel {
    var repo = PhotoRepositories()
    var photos = [Photo]()
    var cellViewModels = [CellViewModel]()

    func fetchPhoto(photoIds: [String], complete: @escaping ([CellViewModel]?) -> Void) {
        let group = DispatchGroup()
        photoIds.forEach { id in
            DispatchQueue.global(qos: .background).async(group: group) {
                group.enter()
                let request = PhotoRequest(id: id)
                self.repo.fetchAPhoto(request: request) { [weak self] result in
                    switch result {
                    case .failure(let error):
                        print(error)
                    case .success(let photo):
                        self?.photos.append(photo)
                        if let imageUrl = photo.urls?.regular,
                            let width = photo.width,
                            let height = photo.height,
                            let color = photo.color {
                            
                            let cellViewModel = CellViewModel(imagePath: imageUrl,
                                                              imageHeight: height,
                                                              imageWidth: width,
                                                              backgroundColor: color)
                            self?.cellViewModels.append(cellViewModel)
                        }
                    }
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) {
            complete(self.cellViewModels)
        }
        
    }
}
