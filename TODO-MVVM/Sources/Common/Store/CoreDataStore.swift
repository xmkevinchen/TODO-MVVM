//
//  CoreDataStore.swift
//  TODO-MVVM
//
//  Created by Chen, Kai on 7/25/17.
//  Copyright © 2017 Chen, Kai. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStore {

    static var shared: CoreDataStore = {
        do {
            return try CoreDataStore()
        } catch {
            fatalError()
        }
    }()

    enum CoreDataStoreError: Error {
        case initialized
        case newEntity
    }

    private let persistentStoreCoordinator: NSPersistentStoreCoordinator
    private let managedObjectModel: NSManagedObjectModel
    private let managedObjectContext: NSManagedObjectContext

    private init() throws {
        if let managedObjectModel = NSManagedObjectModel.mergedModel(from: nil),
            let applicationDocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
        {
            self.managedObjectModel = managedObjectModel
            self.persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)

            let options = [
                NSMigratePersistentStoresAutomaticallyOption: true,
                NSInferMappingModelAutomaticallyOption: true
            ]

            let storeURL = applicationDocumentsDirectory.appendingPathComponent("MVVM-Todo.sqlite")
            print("===> storeURL: \(storeURL)")

            try self.persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: options)

            self.managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
            self.managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
            self.managedObjectContext.undoManager = nil
            
        } else {
            throw CoreDataStoreError.initialized
        }

    }

    func fetchEntries(with predicate: NSPredicate? = nil,
                      sortBy: [NSSortDescriptor]? = nil,
                      completionHandler: @escaping ([ManagedTodoItem]) -> Void) {

        let fetchRequest: NSFetchRequest = ManagedTodoItem.fetchRequest()
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortBy
        managedObjectContext.perform { [weak self] _ in

            guard let wself = self, let results = try? wself.managedObjectContext.fetch(fetchRequest) else {
                completionHandler([])
                return
            }

            completionHandler(results)
        }
    }

    func save() throws {
        try managedObjectContext.save()
    }

    func new() throws -> ManagedTodoItem {
        guard
            let entityDescription = NSEntityDescription.entity(forEntityName: "TodoItem", in: managedObjectContext),
            let entity = NSManagedObject(entity: entityDescription,
                                         insertInto: managedObjectContext) as? ManagedTodoItem
            else {
            throw CoreDataStoreError.newEntity
        }

        return entity
    }


}
