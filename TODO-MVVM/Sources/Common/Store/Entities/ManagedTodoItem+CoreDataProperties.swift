//
//  ManagedTodoItem+CoreDataProperties.swift
//  TODO-MVVM
//
//  Created by Chen, Kai on 7/31/17.
//  Copyright © 2017 Chen, Kai. All rights reserved.
//

import Foundation
import CoreData


extension ManagedTodoItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedTodoItem> {
        return NSFetchRequest<ManagedTodoItem>(entityName: "TodoItem")
    }

    @NSManaged public var dueDate: NSDate?
    @NSManaged public var memo: String?
    @NSManaged public var name: String?

}
