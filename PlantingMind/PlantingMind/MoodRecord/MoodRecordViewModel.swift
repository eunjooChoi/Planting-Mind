//
//  MoodRecordViewModel.swift
//  PlantingMind
//
//  Created by 최은주 on 3/2/24.
//

import Foundation
import CoreData

class MoodRecordViewModel: ObservableObject {
    private let context: NSManagedObjectContext
    private let date: Date?
    
    @Published var mood: Mood
    @Published var reason: String
    
    init(context: NSManagedObjectContext, calendarModel: CalendarModel, moodRecord: MoodRecord?) {
        self.context = context
        self.date = Calendar.current.date(from: DateComponents(year: calendarModel.year,
                                                               month: calendarModel.month,
                                                               day: calendarModel.day))
        
        self.mood = Mood(rawValue: moodRecord?.mood ?? Mood.normal.rawValue) ?? .normal
        self.reason = moodRecord?.reason ?? ""
    }
    
    func save() {
        guard let date = self.date else { return }
        let timestamp = date.timeStampString()
        
        let fetchRequest = NSFetchRequest<MoodRecord>(entityName: "MoodRecord")
        let predicate = NSPredicate(format: "timestamp == %@", timestamp)
        fetchRequest.predicate = predicate
        
        do {
            let result = try context.fetch(fetchRequest)
            
            if result.count == 1 {
                let record = result[0]
                record.mood = self.mood.rawValue
                record.reason = self.reason
            } else {
                let record = MoodRecord(context: context)
                record.timestamp = timestamp
                record.mood = self.mood.rawValue
                record.reason = self.reason
            }
            try context.save()
        } catch {
            print("Failed to save the mood record", error.localizedDescription)
        }
        
        self.sendFetchNotification()
    }
    
    /**
     CalendarGridView의 기분을 업데이트 하도록 노티 발송
     */
    private func sendFetchNotification() {
        NotificationCenter.default.post(name: .fetchNotification,
                                        object: nil)
    }
}
