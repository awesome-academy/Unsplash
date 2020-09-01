//
//  RealmManager.swift
//  Unsplash
//
//  Created by Nha Pham on 9/1/20.
//  Copyright © 2020 Nha Pham. All rights reserved.
//

import RealmSwift

final class RealmManager {
    static var shared = RealmManager()
    var realm: Realm? {
        get {
            do {
                return try Realm()
            }
            catch {
                return nil
            }
        }
    }

    func fetchData<T: Object>() -> Results<T>? {
        let results = realm?.objects(T.self)
        guard let result = results?.sorted(byKeyPath: "date", ascending: false) else {
            return nil
        }
        return result
    }

    func addData(data: Object) {
        do {
            try realm?.write {
                realm?.add(data)
            }
        } catch {
            print("Error add data")
        }
    }
    
    func deleteData(data: Object) {
        do {
            try realm?.write {
                realm?.delete(data)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
