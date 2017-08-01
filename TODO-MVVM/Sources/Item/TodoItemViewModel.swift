//
//  TodoItemViewModel.swift
//  TODO-MVVM
//
//  Created by Chen, Kai on 7/25/17.
//  Copyright © 2017 Chen, Kai. All rights reserved.
//

import Foundation

class TodoItemViewModel {

    var minimumDate: Date

    var selectedDate: Date? {
        
        didSet {
            
            guard oldValue != selectedDate else {
                return
            }

            if let date = selectedDate {
                formattedDate = formatter.string(from: date)
            } else {
                formattedDate = nil
            }
        }
    }

    var formattedDate: String?

    private let dataManager: TodoAddDataManager
    let formatter: DateFormatter

    init(dataManager: TodoAddDataManager, minimumDate: Date) {
        self.dataManager = dataManager
        formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .long

        self.minimumDate = minimumDate
        self.selectedDate = minimumDate
        formattedDate = formatter.string(from: minimumDate)


    }

    func save(name: String, dueDate: Date) {
        let item = TodoItem(dueDate: dueDate, name: name, memo: nil)
        dataManager.add(item: item)
    }
    

}
