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
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        return formatter
    }
    
    @Published var mood: Mood
    @Published var reason: String
    
    init(context: NSManagedObjectContext, calendarModel: CalendarModel) {
        self.context = context
        self.calendarModel = calendarModel
        self.date = Calendar.current.date(from: DateComponents(year: calendarModel.year,
                                                               month: calendarModel.month,
                                                               day: calendarModel.day))
        self.mood = .normal
        self.reason = ""
    }
    
    func fetch() {
        guard let date = date else { return }
        
        let timestamp = dateFormatter.string(from: date)
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MoodRecord")
        let predicate = NSPredicate(format: "timestamp == %@", timestamp)
        fetchRequest.predicate = predicate
        
        do {
            guard let result = try context.fetch(fetchRequest) as? [MoodRecord],
                let record = result.first else { return }
            
            self.mood = Mood(rawValue: record.mood) ?? .normal
            self.reason = record.reason ?? ""
            
        } catch {
            print("Failed to fetch the mood record", error.localizedDescription)
        }
    }
    
    func save() {
        guard let entity = NSEntityDescription.entity(forEntityName: "MoodRecord", in: context) else { return }
        guard let date = date else { return }
        let timestamp = dateFormatter.string(from: date)
        
        let object = NSManagedObject(entity: entity, insertInto: context)
        object.setValue(timestamp, forKey: "timestamp")
        object.setValue(mood.rawValue, forKey: "mood")
        object.setValue(reason, forKey: "reason")
        
        do {
            try context.save()
        } catch {
            print("Failed to save the mood record", error.localizedDescription)
        }
    }
}
