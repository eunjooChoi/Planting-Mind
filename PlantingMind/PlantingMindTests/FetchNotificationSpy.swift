//
//  FetchNotificationSpy.swift
//  PlantingMindTests
//
//  Created by 최은주 on 3/8/24.
//

import Foundation
import CoreData
@testable import PlantingMind

final class FetchNotificationSpy {
    private var context: NSManagedObjectContext
    var bindNoticiationIsCalled = false
    
    init(context: NSManagedObjectContext) {
        self.context = context
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(toggleProperty),
                                               name: .fetchNotification,
                                               object: nil)
        
    }
    
    @objc private func toggleProperty() {
        self.bindNoticiationIsCalled.toggle()
    }
    
    func sendNoticiation() {
        self.saveCoreData()
        
        let timestamp = "2024-01"
        
        let fetchRequest = NSFetchRequest<MoodRecord>(entityName: "MoodRecord")
        let predicate = NSPredicate(format: "%K CONTAINS[cd] %@", #keyPath(MoodRecord.timestamp), timestamp)
        fetchRequest.predicate = predicate
        
        do {
            let result = try context.fetch(fetchRequest)
            print("context.count = \(result.count)")
            
        } catch {
            print("Failed to fetch the mood records", error.localizedDescription)
        }
        
        NotificationCenter.default.post(name: .fetchNotification, object: nil)
    }
    
    private func saveCoreData() {
        let moodRecord = MoodRecord(context: context)
        moodRecord.timestamp = "2024-01-07"
        moodRecord.mood = Mood.good.rawValue
        moodRecord.reason = "i wanna sleep"
        
        do {
            try context.save()
        } catch {
            print("save failed")
        }
    }
}
