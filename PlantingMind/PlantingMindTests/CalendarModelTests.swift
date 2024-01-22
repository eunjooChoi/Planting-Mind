//
//  CalendarModelTests.swift
//  PlantingMindTests
//
//  Created by 최은주 on 1/22/24.
//

import XCTest
@testable import PlantingMind

final class CalendarModelTests: XCTestCase {
    override class func setUp() {
        super.setUp()
    }

    override class func tearDown() {
        super.tearDown()
    }
    
    func test_날짜_앞에_nil이_제대로_들어갔는지_확인() throws {
        let date = Calendar.current.date(from: DateComponents(year: 2024,
                                                              month: 1,
                                                              day: 1))
        
        let viewModel = CalendarViewModel(today: date!)
        let nilCount = viewModel.days.filter { $0 == nil }.count
        XCTAssertEqual(nilCount, 1) // 24년 1월은 월요일부터 시작이므로 nil이 하나 있어야 한다.
    }

    func test_이전_달로_이동() throws {
        let date = Calendar.current.date(from: DateComponents(year: 2024,
                                                              month: 1,
                                                              day: 1))
        
        let viewModel = CalendarViewModel(today: date!)
        viewModel.addingMonth(value: -1)
        
        let nilCount = viewModel.days.filter { $0 == nil }.count
        XCTAssertEqual(nilCount, 5) // 23년 12월은 금요일부터 시작이므로 nil이 5개 있어야 한다.
    }
    
    func test_다음_달로_이동() throws {
        let date = Calendar.current.date(from: DateComponents(year: 2024,
                                                              month: 1,
                                                              day: 1))
        
        let viewModel = CalendarViewModel(today: date!)
        viewModel.addingMonth(value: 1)
        
        let nilCount = viewModel.days.filter { $0 == nil }.count
        XCTAssertEqual(nilCount, 4) // 24년 2월은 목요일부터 시작이므로 nil이 하나 있어야 한다.
    }

}
