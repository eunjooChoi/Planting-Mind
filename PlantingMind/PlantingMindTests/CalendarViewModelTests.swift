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
    var context = CoreDataStack(.inMemory).persistentContainer.viewContext
    var viewModel: CalendarViewModel!
    
    override func setUp() {
        super.setUp()
        
        let date = Calendar.current.date(from: DateComponents(year: 2024,
                                                              month: 1,
                                                              day: 1))
        
        viewModel = CalendarViewModel(today: date!, context: context)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_날짜_앞에_nil이_제대로_들어갔는지_확인() throws {
        let nilCount = viewModel.days.filter { $0 == nil }.count
        XCTAssertEqual(nilCount, 1) // 24년 1월은 월요일부터 시작이므로 nil이 하나 있어야 한다.
    }
    
    func test_이전_달로_이동() throws {
        viewModel.addingMonth(value: -1)
        
        let nilCount = viewModel.days.filter { $0 == nil }.count
        XCTAssertEqual(nilCount, 5) // 23년 12월은 금요일부터 시작이므로 nil이 5개 있어야 한다.
    }
    
    func test_다음_달로_이동() throws {
        viewModel.addingMonth(value: 1)
        
        let nilCount = viewModel.days.filter { $0 == nil }.count
        XCTAssertEqual(nilCount, 4) // 24년 2월은 목요일부터 시작이므로 nil이 하나 있어야 한다.
    }
    
    func test_해당_월의_mood_list_가져오기() throws {
        setupCoreData()
        viewModel.fetch()
        
        let expectedRecordsCount = 3
        XCTAssertTrue(viewModel.moods.count == expectedRecordsCount)
    }
    
    func test_원하는_날짜의_mood_받기() throws {
        setupCoreData()
        viewModel.fetch()
        
        let result = viewModel.mood(of: CalendarModel(year: 2024,
                                                          month: 1,
                                                          day: 1,
                                                          isToday: false))
        
        let expectedMood = Mood.normal.rawValue
        
        XCTAssertEqual(result?.mood, expectedMood)
        XCTAssertNil(result?.reason)
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
        
        do{
            try context.save()
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
