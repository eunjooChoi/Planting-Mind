//
//  DayCellViewModelTest.swift
//  PlantingMindTests
//
//  Created by 최은주 on 3/7/24.
//

import XCTest
import SwiftUI
@testable import PlantingMind

final class DayCellViewModelTest: XCTestCase {
    func test_DayCellModel_record_nil() throws {
        let model = DayCellViewModel(calendarModel: CalendarModel(year: 2024, month: 2, day: 24, isToday: false),
                                     moodRecord: nil)
        
        XCTAssertNil(model.mood)
        XCTAssertEqual(model.moodForegroundColor, .clear)
        XCTAssertNil(model.moodEmoji)
    }
    
    func test_DayCellModel_record_non_nil() throws {
        let coreDataStack = CoreDataStack(.inMemory)
        let moodRecord = MoodRecord(context: coreDataStack.persistentContainer.viewContext)
        moodRecord.timestamp = "2024-02-24"
        moodRecord.mood = Mood.nice.rawValue
        
        let model = DayCellViewModel(calendarModel: CalendarModel(year: 2024, month: 2, day: 24, isToday: false),
                                     moodRecord: moodRecord)
        
        XCTAssertEqual(Mood.nice, model.mood)
        XCTAssertEqual(model.moodForegroundColor, Color.Custom.nice)
        XCTAssertEqual(model.moodEmoji, Image("nice_emoji", bundle: nil))
    }
    
    func test_isToday_true_날짜색() throws {
        let model = DayCellViewModel(calendarModel: CalendarModel(year: 2024, month: 2, day: 24, isToday: true),
                                     moodRecord: nil)
        
        XCTAssertEqual(model.dayForegroundColor, Color.Custom.point)
        XCTAssertEqual(model.dayBackgroundColor, Color.Custom.general)
    }
    
    func test_isToday_false_날짜색() throws {
        let model = DayCellViewModel(calendarModel: CalendarModel(year: 2024, month: 2, day: 24, isToday: false),
                                     moodRecord: nil)
        
        XCTAssertEqual(model.dayForegroundColor, Color.Custom.general)
        XCTAssertEqual(model.dayBackgroundColor, .clear)
    }
}
