//
//  MoodRecordViewModelTests.swift
//  PlantingMindTests
//
//  Created by 최은주 on 3/3/24.
//

import XCTest
import CoreData
@testable import PlantingMind

final class MoodRecordViewModelTests: XCTestCase {
    var coreDataStack: CoreDataStack!
    var calendarModel: CalendarModel!
    
    override func setUp() {
        super.setUp()
        self.coreDataStack = CoreDataStack(.inMemory)
        self.calendarModel = CalendarModel(year: 2024, month: 2, day: 24, isToday: true)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_기분_데이터_없을_때_기본값_확인() throws {
        let viewModel = MoodRecordViewModel(context: coreDataStack.persistentContainer.viewContext,
                                            calendarModel: calendarModel,
                                            moodRecord: nil)
        
        // 데이터 없을 때 패치하면 moodRecord에 값이 없음
        
        let expectedMood = Mood.normal
        let expectedReason = ""
        
        XCTAssertEqual(viewModel.mood, expectedMood)
        XCTAssertEqual(viewModel.reason, expectedReason)
    }
    
    func test_기분_데이터_넘겨주는_경우() throws {
        let moodRecord = MoodRecord(context: coreDataStack.persistentContainer.viewContext)
        moodRecord.mood = Mood.nice.rawValue
        moodRecord.reason = "reason reason"
        
        let viewModel = MoodRecordViewModel(context: coreDataStack.persistentContainer.viewContext,
                                            calendarModel: calendarModel,
                                            moodRecord: moodRecord)
        
        // 넘겨준 데이터로 초기화
        let expectedMood = Mood.nice
        let expectedReason = "reason reason"
        
        XCTAssertEqual(viewModel.mood, expectedMood)
        XCTAssertEqual(viewModel.reason, expectedReason)
    }
    
    func test_수정_후_저장_확인() throws {
        let moodRecord = MoodRecord(context: coreDataStack.persistentContainer.viewContext)
        moodRecord.mood = Mood.nice.rawValue
        moodRecord.reason = "reason reason"
        
        let viewModel = MoodRecordViewModel(context: coreDataStack.persistentContainer.viewContext,
                                            calendarModel: calendarModel,
                                            moodRecord: moodRecord)
        
        let expectedMood = Mood.normal
        let expectedReason = "Change Reason"
        
        viewModel.mood = expectedMood
        viewModel.reason = expectedReason
        viewModel.save()
        
        let record = self.fetch()
        
        XCTAssertNotNil(record)
        XCTAssertEqual(record?.mood, expectedMood.rawValue)
        XCTAssertEqual(record?.reason, expectedReason)
    }
    
    func test_notification_발송() throws {
        let viewModel = MoodRecordViewModel(context: coreDataStack.persistentContainer.viewContext,
                                            calendarModel: calendarModel,
                                            moodRecord: nil)
        
        let mock = FetchNotificationSpy(context: coreDataStack.persistentContainer.viewContext)
        viewModel.save()
        
        XCTAssertTrue(mock.bindNoticiationIsCalled)
    }
    
    private func fetch() -> MoodRecord? {
        let timestamp = "2024-02-24"
        
        let fetchRequest = NSFetchRequest<MoodRecord>(entityName: "MoodRecord")
        let predicate = NSPredicate(format: "timestamp == %@", timestamp)
        fetchRequest.predicate = predicate
        
        do {
            let result = try coreDataStack.persistentContainer.viewContext.fetch(fetchRequest)
            return result.first
            
        } catch {
            print("Failed to fetch the mood record", error.localizedDescription)
        }
        
        return nil
    }
}
