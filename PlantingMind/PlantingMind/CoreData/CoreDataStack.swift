//
//  CoreDataStack.swift
//  PlantingMind
//
//  Created by 최은주 on 2/29/24.
//

import Foundation
import CoreData

enum StorageType {
    case persistent
    case inMemory
}

final class CoreDataStack: ObservableObject {
    let persistentContainer: NSPersistentContainer
    private let datebaseName = "PlantingMind.sqlite"
    
    var sharedStoreURL: URL? {
        let container = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.eunjoo.planting-mind.PlantingMind")
        return container?.appendingPathComponent(datebaseName)
    }
    
    init(_ storageType: StorageType = .persistent) {
        self.persistentContainer = NSPersistentContainer(name: "MoodRecords")
        
        // test setup
        if storageType == .inMemory {
            let description = NSPersistentStoreDescription(url: URL(filePath: "dev/null"))
            self.persistentContainer.persistentStoreDescriptions = [description]
        } else {
            self.persistentContainer.persistentStoreDescriptions.first?.url = self.sharedStoreURL
        }
        
        self.persistentContainer.loadPersistentStores { _, error in
            if let error {
                fatalError("Failed to load persistent stores: \(error.localizedDescription)")
            }
        }
    }
}

extension CoreDataStack {
    func save() {
        let viewContext = persistentContainer.viewContext
        
        guard viewContext.hasChanges else { return }
        
        do {
            try viewContext.save()
        } catch {
            print("Failed to save the context:", error.localizedDescription)
        }
    }
}
