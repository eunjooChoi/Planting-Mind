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
    @Published var moodRecord: MoodRecord
    
    init(context: NSManagedObjectContext, calendarModel: CalendarModel) {
        self.context = context
        self.calendarModel = calendarModel
        self.moodRecord = MoodRecord(context: context)
    }
    
    func fetch() {
        
    }
    
    func save(mood: Mood, reason: String?) {
        
    }
}
