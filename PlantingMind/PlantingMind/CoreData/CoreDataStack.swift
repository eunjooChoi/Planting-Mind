//
//  CoreDataStack.swift
//  PlantingMind
//
//  Created by 최은주 on 2/29/24.
//

import Foundation
import CoreData

class CoreDataStack: ObservableObject {
    static let shared = CoreDataStack()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MoodRecords")
        
        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Failed to load persistent stores: \(error.localizedDescription)")
            }
        }
        return container
    }()
        
    private init() { }
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
