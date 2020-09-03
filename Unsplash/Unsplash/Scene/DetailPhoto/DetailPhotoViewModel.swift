//
//  DetailPhotoViewModel.swift
//  Unsplash
//
//  Created by Nha Pham on 9/1/20.
//  Copyright © 2020 Nha Pham. All rights reserved.
//

import Foundation
import RealmSwift

final class DetailPhotoViewModel {
    let realmManager = RealmManager.shared

    func isObjectExist (id: String) -> Bool {
        return realmManager.realm?.object(ofType: Store.self, forPrimaryKey: id) != nil
    }

    func addPhotoToStore(imageId: String) {
        let store = Store()
        store.imageId = imageId
        realmManager.addData(data: store)
    }

    func removePhotoFromStore(imageId: String) {
        let photo = realmManager.realm?.object(ofType: Store.self, forPrimaryKey: "\(imageId)")
        if let photo = photo {
            realmManager.deleteData(data: photo)
        }
    }
    
}
