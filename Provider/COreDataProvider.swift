//
//  CoreDataProvider.swift
//  notes
//
//  Created by vishnuprasad on 08/06/25.
//

import Foundation
import CoreData

class CoreDataProvider {
    let persistantContainer : NSPersistentContainer
    var viewContext : NSManagedObjectContext {
        persistantContainer.viewContext
    }
    static var preview : CoreDataProvider = {
        let provider = CoreDataProvider(inMemory: true)  // In-memory only
        let context = provider.viewContext
        // Creates 10 sample ToDoItems for preview
        for index in 1...10 {
            let todoItem = ToDoItem(context: context)
            todoItem.title = "\(index)"
        }
        do {
            try context.save()
        }
        catch {
            print("Error")
        }
        return provider
    }()
    
    
    init(inMemory: Bool = false) {
        // 1. Create the persistent container (references your .xcdatamodeld file)
        self.persistantContainer = NSPersistentContainer(name: "notes")
        // 2. For previews/testing, store data in memory instead of disk
        if inMemory {
            persistantContainer.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        // 3. Load the persistent stores (connects to actual database)
        persistantContainer.loadPersistentStores { _, error in
            if let error {
                fatalError("Error \(error)") // App crashes if database can't load
            }
        }
    }
}
