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
        XCTAssertTrue(viewModel.isFirstRecord)
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
        
        viewModel.save()
        
        let expectedMood = Mood.normal
        let expectedReason = "Change Reason"
        
        viewModel.mood = expectedMood
        viewModel.reason = expectedReason
        viewModel.save()
        
        let record = try self.fetch()
        
        XCTAssertNotNil(record)
        XCTAssertEqual(record?.mood, expectedMood.rawValue)
        XCTAssertEqual(record?.reason, expectedReason)
    }
    
    func test_기록_삭제_확인() throws {
        let moodRecord = MoodRecord(context: coreDataStack.persistentContainer.viewContext)
        moodRecord.mood = Mood.nice.rawValue
        moodRecord.reason = "reason reason"
        
        let viewModel = MoodRecordViewModel(context: coreDataStack.persistentContainer.viewContext,
                                            calendarModel: calendarModel,
                                            moodRecord: moodRecord)
        
        viewModel.deleteRecord { result in
            // 기록 저장안한 경우 false 리턴
            XCTAssertFalse(result)
        }
        
        viewModel.save()
        viewModel.deleteRecord { result in
            XCTAssertTrue(result)
        }
        
        let record = try self.fetch()
        XCTAssertNil(record)
    }
    
    func test_취소했을_때_변경사항_없는_경우() throws {
        let moodRecord = MoodRecord(context: coreDataStack.persistentContainer.viewContext)
        moodRecord.mood = Mood.nice.rawValue
        moodRecord.reason = "reason reason"
        
        let viewModel = MoodRecordViewModel(context: coreDataStack.persistentContainer.viewContext,
                                            calendarModel: calendarModel,
                                            moodRecord: moodRecord)
        
        let expectedResult = false
        let result = viewModel.needCancelAlert()
        
        XCTAssertEqual(expectedResult, result)
    }
    
    func test_취소했을_때_변경사항_있는_경우() throws {
        let moodRecord = MoodRecord(context: coreDataStack.persistentContainer.viewContext)
        moodRecord.mood = Mood.nice.rawValue
        moodRecord.reason = "reason reason"
        
        let viewModel = MoodRecordViewModel(context: coreDataStack.persistentContainer.viewContext,
                                            calendarModel: calendarModel,
                                            moodRecord: moodRecord)
        
        viewModel.mood = Mood.normal
        
        let expectedResult = true
        let result = viewModel.needCancelAlert()
        
        XCTAssertEqual(expectedResult, result)
    }
    
    func test_notification_발송() throws {
        let viewModel = MoodRecordViewModel(context: coreDataStack.persistentContainer.viewContext,
                                            calendarModel: calendarModel,
                                            moodRecord: nil)
        
        let mock = FetchNotificationSpy(context: coreDataStack.persistentContainer.viewContext)
        viewModel.save()
        
        XCTAssertTrue(mock.bindNoticiationIsCalled)
    }
    
    private func fetch() throws -> MoodRecord? {
        let timestamp = try XCTUnwrap(Calendar.current.date(from: DateComponents(year: 2024,
                                                                                 month: 2,
                                                                                 day: 24)))
        
        let fetchRequest = NSFetchRequest<MoodRecord>(entityName: "MoodRecord")
        let predicate = NSPredicate(format: "timestamp == %@", timestamp as NSDate)
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
