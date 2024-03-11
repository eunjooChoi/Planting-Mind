//
//  DayCellViewModel.swift
//  PlantingMind
//
//  Created by 최은주 on 3/7/24.
//

import Foundation
import SwiftUI

class DayCellViewModel: ObservableObject {
    let today: Date
    let moodRecord: MoodRecord?
    let calendarModel: CalendarModel
    
    var mood: Mood? {
        guard let moodRecord = self.moodRecord else { return nil }
        return Mood(rawValue: moodRecord.mood)
    }
    
    var dayForegroundColor: Color {
        if self.isFutureDate {
            return Color.gray
        } else {
            return self.calendarModel.isToday ? Color.Custom.point : Color.Custom.general
        }
    }
    
    var dayBackgroundColor: Color {
        self.calendarModel.isToday ? Color.Custom.general : .clear
    }
    
    var moodForegroundColor: Color {
        guard let mood = self.mood else { return .clear }
        return mood.color
    }
    
    var moodEmoji: Image? {
        guard let mood = self.mood else { return nil }
        return Image(mood.emojiName, bundle: nil)
    }
    
    var isFutureDate: Bool {
        guard let date = Calendar.current.date(from: DateComponents(year: self.calendarModel.year,
                                                                    month: self.calendarModel.month,
                                                                    day: self.calendarModel.day)) else { return false }
        return date > self.today
    }
    
    init(today: Date, calendarModel: CalendarModel, moodRecord: MoodRecord?) {
        self.today = today
        self.calendarModel = calendarModel
        self.moodRecord = moodRecord
    }
}
