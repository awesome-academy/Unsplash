//
//  SearchHistory.swift
//  Unsplash
//
//  Created by Nha Pham on 9/3/20.
//  Copyright © 2020 Nha Pham. All rights reserved.
//

import RealmSwift

class SearchHistory: Object {
    @objc dynamic var searchKey: String = ""
    @objc dynamic var date: Date = Date()
}
