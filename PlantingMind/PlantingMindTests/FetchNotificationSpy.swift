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
        
        let startOfMonth = Calendar.current.date(from: DateComponents(year: 2024,
                                                                      month: 1,
                                                                      day: 1))!
        
        let endOfMonth = Calendar.current.date(from: DateComponents(year: 2024,
                                                                      month: 1,
                                                                      day: 31))!
        
        let fetchRequest = NSFetchRequest<MoodRecord>(entityName: "MoodRecord")
        let predicate = NSPredicate(format: "%K >= %@ && %K <= %@", #keyPath(MoodRecord.timestamp), startOfMonth as NSDate, #keyPath(MoodRecord.timestamp), endOfMonth as NSDate)
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
        moodRecord.timestamp = Calendar.current.date(from: DateComponents(year: 2024,
                                                                          month: 1,
                                                                          day: 7))!
        moodRecord.mood = Mood.good.rawValue
        moodRecord.reason = "i wanna sleep"
        
        do {
            try context.save()
        } catch {
            print("save failed")
        }
    }
}
