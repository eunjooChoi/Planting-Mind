//
//  DayCellModel.swift
//  PlantingMind
//
//  Created by 최은주 on 3/7/24.
//

import Foundation

struct DayCellModel {
    private let moodRecord: MoodRecord?
    let calendarModel: CalendarModel
    
    var mood: Mood? {
        guard let moodRecord = moodRecord else { return nil }
        return Mood(rawValue: moodRecord.mood)
    }
    
    init(calendarModel: CalendarModel, moodRecord: MoodRecord?) {
        self.calendarModel = calendarModel
        self.moodRecord = moodRecord
    }
}
