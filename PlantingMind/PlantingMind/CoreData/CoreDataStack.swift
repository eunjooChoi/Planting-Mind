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
    
    private struct Constant {
        static let identifier = "group.eunjoo.planting-mind.PlantingMind"
        static let datebaseName = "PlantingMind.sqlite"
        static let containerName = "MoodRecords"
        static let testFilePath = "dev/null"
    }
    
    var sharedStoreURL: URL? {
        let container = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: Constant.identifier)
        return container?.appendingPathComponent(Constant.datebaseName)
    }
    
    init(_ storageType: StorageType = .persistent) {
        self.persistentContainer = NSPersistentContainer(name: Constant.containerName)
        
        // test setup
        if storageType == .inMemory {
            let description = NSPersistentStoreDescription(url: URL(filePath: Constant.testFilePath))
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
