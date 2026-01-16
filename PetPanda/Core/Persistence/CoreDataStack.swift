//
//  CoreDataStack.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 16.01.2026.
//

import Foundation
import CoreData

final class CoreDataStack {

    let persistentContainer: NSPersistentContainer

    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    init(modelName: String = "PetPanda") {
        persistentContainer = NSPersistentContainer(name: modelName)
        load()
    }

    private func load() {
        persistentContainer.loadPersistentStores { _, error in
            if let error {
                fatalError("❌ CoreData load error: \(error)")
            }
        }

        persistentContainer.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }
}
