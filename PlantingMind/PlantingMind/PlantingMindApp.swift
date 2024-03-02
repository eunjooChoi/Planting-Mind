//
//  PlantingMindApp.swift
//  PlantingMind
//
//  Created by 최은주 on 1/3/24.
//

import SwiftUI

@main
struct PlantingMindApp: App {
    @StateObject private var coreDataStack = CoreDataStack()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext,
                              coreDataStack.persistentContainer.viewContext)
        }
    }
}
