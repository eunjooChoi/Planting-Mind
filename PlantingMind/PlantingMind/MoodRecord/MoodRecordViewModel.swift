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
    private let calendarModel: CalendarModel
    private let date: Date?
    
    @Published var moodRecord: MoodRecord
    
    init(context: NSManagedObjectContext, calendarModel: CalendarModel) {
        self.context = context
        self.calendarModel = calendarModel
        self.moodRecord = MoodRecord(context: context)
        self.date = Calendar.current.date(from: DateComponents(year: calendarModel.year,
                                                               month: calendarModel.month,
                                                               day: calendarModel.day,
                                                               hour: 0,
                                                               minute: 0,
                                                               second: 0))
    }
    
    func fetch() {
        guard let date = date else { return }
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MoodRecord")
        let predicate = NSPredicate(format: "date == %@", date as NSDate)
        fetchRequest.predicate = predicate
        
        do {
            guard let result = try context.fetch(fetchRequest) as? [MoodRecord],
                let record = result.first else { return }
            
            self.moodRecord = record
        } catch {
            print("Failed to fetch the mood record", error.localizedDescription)
        }
    }
    
    func save(mood: Mood, reason: String?) {
        guard let entity = NSEntityDescription.entity(forEntityName: "MoodRecord", in: context) else { return }
        guard let date = date else { return }
        
        let object = NSManagedObject(entity: entity, insertInto: context)
        object.setValue(date, forKey: "date")
        object.setValue(mood.rawValue, forKey: "mood")
        object.setValue(reason, forKey: "reason")
        
        do {
            try context.save()
        } catch {
            print("Failed to save the mood record", error.localizedDescription)
        }
    }
}
