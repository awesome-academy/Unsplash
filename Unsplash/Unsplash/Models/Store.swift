//
//  Store.swift
//  Unsplash
//
//  Created by Nha Pham on 9/1/20.
//  Copyright © 2020 Nha Pham. All rights reserved.
//

import RealmSwift

class Store: Object {
    @objc dynamic var imageId: String = ""
    @objc dynamic var date: Date = Date()
    override class func primaryKey() -> String? {
        return "imageId"
    }
}
