//
//  MoodRecordViewModelTests.swift
//  PlantingMindTests
//
//  Created by 최은주 on 3/3/24.
//

import XCTest
@testable import PlantingMind

final class MoodRecordViewModelTests: XCTestCase {
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        return formatter
    }
    
    var viewModel: MoodRecordViewModel!
    
    override func setUp() {
        super.setUp()
        let coreDataStack = CoreDataStack(.inMemory)
        let calendarModel = CalendarModel(year: 2024, month: 2, day: 24, isToday: true)
        
        viewModel = MoodRecordViewModel(context: coreDataStack.persistentContainer.viewContext,
                                        calendarModel: calendarModel)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_데이터_없을_때_패치() throws {
        // 데이터 없을 때 패치하면 moodRecord에 값이 없음
        viewModel.fetch()
        
        let expectedMood = Mood.normal
        
        XCTAssertEqual(viewModel.mood, expectedMood)
        XCTAssertTrue(viewModel.reason.isEmpty)
    }
    
    func test_데이터_저장_후_패치() throws {
        // 데이터 저장 후 패치 하면 moodRecord에 값이 들어있음
        
        let expectedMood = Mood.nice
        let expectedReason = "reason reason"
        
        viewModel.mood = .nice
        viewModel.reason = "reason reason"
        viewModel.save()
        viewModel.fetch()
        
        XCTAssertEqual(viewModel.mood, expectedMood)
        XCTAssertEqual(viewModel.reason, expectedReason)
    }
}
