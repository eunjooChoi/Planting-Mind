//
//  DayCellModelTest.swift
//  PlantingMindTests
//
//  Created by 최은주 on 3/7/24.
//

import XCTest
@testable import PlantingMind

final class DayCellModelTest: XCTestCase {
    func test_DayCellModel_record_nil() throws {
        let model = DayCellModel(calendarModel: CalendarModel(year: 2024, month: 2, day: 24, isToday: false),
                                 moodRecord: nil)
        
        XCTAssertNil(model.mood)
    }

    func test_DayCellModel_record_non_nil() throws {
        let coreDataStack = CoreDataStack(.inMemory)
        let moodRecord = MoodRecord(context: coreDataStack.persistentContainer.viewContext)
        moodRecord.timestamp = "2024-02-24"
        moodRecord.mood = Mood.nice.rawValue
        
        let model = DayCellModel(calendarModel: CalendarModel(year: 2024, month: 2, day: 24, isToday: false),
                                 moodRecord: moodRecord)
        
        XCTAssertEqual(Mood.nice, model.mood)
    }
}
