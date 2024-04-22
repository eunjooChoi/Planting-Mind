//
//  PlantingMindApp.swift
//  PlantingMind
//
//  Created by 최은주 on 1/3/24.
//

import SwiftUI
import Firebase

@main
struct PlantingMindApp: App {
    @StateObject private var coreDataStack = CoreDataStack()
    
    init() {
        FirebaseApp.configure()
        
        if UserDefaults.standard.bool(forKey: UserDefaultsKeys.firstLaunch.rawValue) == false {
            UserDefaults.standard.set(22, forKey: UserDefaultsKeys.hour.rawValue)
            UserDefaults.standard.set(true, forKey: UserDefaultsKeys.firstLaunch.rawValue)
        }
        
        let notificationManager = NotificationManager()
        notificationManager.requestPermission()
        notificationManager.addNotification(date: nil)
        UNUserNotificationCenter.current().setBadgeCount(0, withCompletionHandler: nil)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext,
                              coreDataStack.persistentContainer.viewContext)
        }
    }
}
