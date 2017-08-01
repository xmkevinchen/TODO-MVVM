//
//  TodoAddDataManager.swift
//  TODO-MVVM
//
//  Created by Chen, Kai on 7/31/17.
//  Copyright © 2017 Chen, Kai. All rights reserved.
//

import Foundation

class TodoAddDataManager {

    private let dataStore: CoreDataStore

    init(dataStore: CoreDataStore) {
        self.dataStore = dataStore
    }

    func add(item: TodoItem) {
        do {
            let newItem = try dataStore.new()
            newItem.name = item.name
            newItem.dueDate = item.dueDate as NSDate
            try dataStore.save()
        } catch {}
    }
    
}
