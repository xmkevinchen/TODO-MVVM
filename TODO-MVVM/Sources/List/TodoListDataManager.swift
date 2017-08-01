//
//  TodoListDataManager.swift
//  TODO-MVVM
//
//  Created by Chen, Kai on 7/25/17.
//  Copyright © 2017 Chen, Kai. All rights reserved.
//

import Foundation

class TodoListDataManager {

    private let dataStore: CoreDataStore

    init(dataStore: CoreDataStore) {
        self.dataStore = dataStore
    }

    func todoItems(from startDate: Date,
                   to endDate: Date,
                   completionHandler: @escaping (([TodoItem]) -> Void)) {

        let predicate = NSPredicate(format: "(dueDate >= %@) AND (dueDate < %@)", startDate as NSDate, endDate as NSDate)

        dataStore.fetchEntries(with: predicate, sortBy: []) { results in

            let items = results.flatMap { (result: ManagedTodoItem) -> TodoItem? in
                guard let dueDate = result.dueDate as Date?,
                    let name = result.name else {
                        return nil
                }

                return TodoItem(dueDate: dueDate, name: name, memo: result.memo)
            }

            completionHandler(items)
        }
        
    }
    
    
}
