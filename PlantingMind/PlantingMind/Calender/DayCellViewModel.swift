//
//  DayCellViewModel.swift
//  PlantingMind
//
//  Created by 최은주 on 3/7/24.
//

import Foundation
import SwiftUI

struct DayCellViewModel {
    let moodRecord: MoodRecord?
    let calendarModel: CalendarModel
    
    var mood: Mood? {
        guard let moodRecord = self.moodRecord else { return nil }
        return Mood(rawValue: moodRecord.mood)
    }
    
    var dayForegroundColor: Color {
        self.calendarModel.isToday ? Color.Custom.point : Color.Custom.general
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
    
    init(calendarModel: CalendarModel, moodRecord: MoodRecord?) {
        self.calendarModel = calendarModel
        self.moodRecord = moodRecord
    }
}
