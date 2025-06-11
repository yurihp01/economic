//
//  CoreDataTestHelper.swift
//  economicTests
//
//  Created by Yuri on 11/06/25.
//

import CoreData

struct CoreDataTestHelper {
    static var inMemoryContainer: NSPersistentContainer {
        guard let modelURL = Bundle(for: ReceiptEntity.self).url(forResource: "economic", withExtension: "momd"),
              let model = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Failed to load Core Data model")
        }

        let container = NSPersistentContainer(name: "economic", managedObjectModel: model)

        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false
        container.persistentStoreDescriptions = [description]

        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        }

        return container
    }
}
