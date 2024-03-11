//
//  CalendarViewModelTests.swift
//  PlantingMindTests
//
//  Created by 최은주 on 1/22/24.
//

import XCTest
import CoreData
@testable import PlantingMind

final class CalendarViewModelTests: XCTestCase {
    var context: NSManagedObjectContext!
    var viewModel: CalendarViewModel!
    
    override func setUp() {
        super.setUp()
        
        let date = Calendar.current.date(from: DateComponents(year: 2024,
                                                              month: 1,
                                                              day: 1))
        
        context = CoreDataStack(.inMemory).persistentContainer.viewContext
        viewModel = CalendarViewModel(today: date!, context: context)
        setupCoreData()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_날짜_앞에_nil이_제대로_들어갔는지_확인() throws {
        let nilCount = viewModel.days.filter { $0 == nil }.count
        XCTAssertEqual(nilCount, 1) // 24년 1월은 월요일부터 시작이므로 nil이 하나 있어야 한다.
    }
    
    func test_이전_달로_이동() throws {
        let date = Calendar.current.date(from: DateComponents(year: 2024,
                                                              month: 2,
                                                              day: 1))
        
        viewModel = CalendarViewModel(today: date!, context: context)
        viewModel.addingMonth(value: -1)
        
        let nilCount = viewModel.days.filter { $0 == nil }.count
        XCTAssertEqual(nilCount, 1) // 24년 1월은 월요일부터 시작이므로 nil이 1개 있어야 한다.
    }
    
    func test_2024년_1월_이전으로_이동하려는_경우_막기() throws {
        viewModel.addingMonth(value: -1)
        
        // 1월 이전으로 돌아가지 않아야 하므로 nil 갯수 변화 없어야 한다.
        let expectedNilCount = 1
        let nilCount = viewModel.days.filter { $0 == nil }.count
        XCTAssertEqual(nilCount, expectedNilCount)
    }
    
    func test_다음_달로_이동() throws {
        let date = Calendar.current.date(from: DateComponents(year: 2024,
                                                              month: 2,
                                                              day: 1))
        
        viewModel = CalendarViewModel(today: date!, context: context)
        viewModel.currentDate = Calendar.current.date(from: DateComponents(year: 2024,
                                                                           month: 1,
                                                                           day: 1))!
        viewModel.addingMonth(value: 1)
        
        let nilCount = viewModel.days.filter { $0 == nil }.count
        XCTAssertEqual(nilCount, 4) // 24년 2월은 목요일부터 시작이므로 nil이 4개 있어야 한다.
    }
    
    func test_현재_달의_다음_달로_이동하려는_경우_막기() throws {
        viewModel.addingMonth(value: 1)
        
        // 현재 달의 다음달로 넘어가지 않아야 하므로 nil 갯수 변화 없어야 한다.
        let expectedNilCount = 1
        let nilCount = viewModel.days.filter { $0 == nil }.count
        XCTAssertEqual(nilCount, expectedNilCount)
    }
    
    func test_해당_월의_mood_list_가져오기() throws {
        viewModel.fetch()
        
        let expectedRecordsCount = 3
        XCTAssertTrue(viewModel.moods.count == expectedRecordsCount)
    }
    
    func test_원하는_날짜의_mood_받기() throws {
        viewModel.fetch()
        
        let result = viewModel.mood(of: CalendarModel(year: 2024,
                                                      month: 1,
                                                      day: 1,
                                                      isToday: false))
        
        let expectedMood = Mood.normal.rawValue
        XCTAssertEqual(result?.mood, expectedMood)
        XCTAssertNil(result?.reason)
        
        // 저장된 정보 없을 경우 Nil
        let result2 = viewModel.mood(of: CalendarModel(year: 2024,
                                                      month: 1,
                                                      day: 2,
                                                      isToday: false))
        
        XCTAssertNil(result2)
    }
    
    func test_notification_받아서_fetch() {
        viewModel.fetch()
        
        let mock = FetchNotificationSpy(context: context)
        let expectedDataCount = 4
        mock.sendNoticiation()
        
        let notiExpectation = XCTestExpectation(description: "notiExpectation")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            XCTAssertEqual(self.viewModel.moods.count, expectedDataCount)
            notiExpectation.fulfill()
        })

        wait(for: [notiExpectation], timeout: 1.5)
    }
    
    private func setupCoreData() {
        let timestapms = ["2024-02-24", "2024-01-01", "2024-01-06", "2024-01-24"]
        let moods: [Mood] = [.nice, .normal, .notBad, .bad]
        let reasons: [String?] = ["happy birthday", nil, "developing...", "eww"]
        
        for idx in 0..<4 {
            let moodRecord = MoodRecord(context: context)
            moodRecord.timestamp = timestapms[idx]
            moodRecord.mood = moods[idx].rawValue
            moodRecord.reason = reasons[idx]
        }
        
        do {
            try context.save()
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
