//
//  MoodRecordViewModel.swift
//  PlantingMind
//
//  Created by 최은주 on 3/2/24.
//

import Foundation
import CoreData
import WidgetKit

class MoodRecordViewModel: ObservableObject {
    private let context: NSManagedObjectContext
    private let originalMood: Mood
    private let originalReason: String
    
    let date: Date
    let isFirstRecord: Bool
    
    @Published var mood: Mood
    @Published var reason: String
    @Published var showErrorAlert: Bool = false
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy. MM. dd"
        return formatter
    }()
    
    init(context: NSManagedObjectContext, calendarModel: CalendarModel, moodRecord: MoodRecord?) {
        self.context = context
        self.isFirstRecord = moodRecord == nil
        
        self.date = Calendar.current.date(from: DateComponents(year: calendarModel.year,
                                                               month: calendarModel.month,
                                                               day: calendarModel.day)) ?? Date()
        
        let mood = Mood(rawValue: moodRecord?.mood ?? Mood.normal.rawValue) ?? .normal
        let reason = moodRecord?.reason ?? ""
        
        self.mood = mood
        self.reason = reason
        self.originalMood = mood
        self.originalReason = reason
    }
    
    func needCancelAlert() -> Bool {
        guard self.originalReason == self.reason else { return true }
        guard self.originalMood == self.mood else { return true }
        return false
    }
    
    func deleteRecord(completionHandler: (Bool) -> Void) {
        let fetchRequest = NSFetchRequest<MoodRecord>(entityName: "MoodRecord")
        let predicate = NSPredicate(format: "timestamp == %@", date as NSDate)
        fetchRequest.predicate = predicate
        
        do {
            guard let result = try self.context.fetch(fetchRequest).first else {
                completionHandler(false)
                return
            }
            
            context.delete(result)
            try context.save()
            WidgetCenter.shared.reloadAllTimelines()
            
            self.sendFetchNotification()
            completionHandler(true)
        } catch {
            self.showErrorAlert.toggle()
            CrashlyticsLog.shared.record(error: error)
            completionHandler(false)
        }
    }
    
    func save() {
        let fetchRequest = NSFetchRequest<MoodRecord>(entityName: "MoodRecord")
        let predicate = NSPredicate(format: "timestamp == %@", date as NSDate)
        fetchRequest.predicate = predicate
        
        do {
            let result = try self.context.fetch(fetchRequest)
            
            if result.count == 1 {
                let record = result[0]
                record.mood = self.mood.rawValue
                record.reason = self.reason
            } else {
                let record = MoodRecord(context: context)
                record.timestamp = date
                record.mood = self.mood.rawValue
                record.reason = self.reason
            }
            try context.save()
            WidgetCenter.shared.reloadAllTimelines()
        } catch {
            self.showErrorAlert.toggle()
            CrashlyticsLog.shared.record(error: error)
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
