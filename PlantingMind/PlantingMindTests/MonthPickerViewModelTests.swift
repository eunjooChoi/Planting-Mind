//
//  MonthPickerViewModelTests.swift
//  PlantingMindTests
//
//  Created by 최은주 on 3/14/24.
//

import XCTest
@testable import PlantingMind

final class MonthPickerViewModelTests: XCTestCase {
    /*
     테스트 해볼 거
     2023.5월로 되어있을 때 year를 2024년으로 조작했을 때 month가 현재의 달로 변경되는가?
     */
    var viewModel: MonthPickerViewModel!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_selectedYear_Month_세팅() throws {
        let startDate = try XCTUnwrap(Calendar.current.date(from: DateComponents(year: 2024,
                                                                                 month: 1,
                                                                                 day: 1)))
        
        let endDate = try XCTUnwrap(Calendar.current.date(from: DateComponents(year: 2024,
                                                                               month: 4,
                                                                               day: 1)))
        
        let selectedDate = try XCTUnwrap(Calendar.current.date(from: DateComponents(year: 2024,
                                                                                    month: 3,
                                                                                    day: 1)))
        
        let dateRange = DateRange(startDate: startDate,
                                  endDate: endDate)
        
        let viewModel = MonthPickerViewModel(dateRange: dateRange, selectedDate: selectedDate)
        let expectedYear = 2024
        let expectedMonth = 3
        XCTAssertEqual(try XCTUnwrap(viewModel.selectedYear), expectedYear)
        XCTAssertEqual(try XCTUnwrap(viewModel.selectedMonth), expectedMonth)
    }
    
    func test_이전년도는_1월부터_12월까지_다_나와야함() throws {
        let startDate = try XCTUnwrap(Calendar.current.date(from: DateComponents(year: 2023,
                                                                                 month: 1,
                                                                                 day: 1)))
        
        let endDate = try XCTUnwrap(Calendar.current.date(from: DateComponents(year: 2024,
                                                                               month: 4,
                                                                               day: 1)))
        
        let selectedDate = try XCTUnwrap(Calendar.current.date(from: DateComponents(year: 2024,
                                                                                    month: 3,
                                                                                    day: 1)))
        let dateRange = DateRange(startDate: startDate,
                                  endDate: endDate)
        
        let viewModel = MonthPickerViewModel(dateRange: dateRange, selectedDate: selectedDate)
        viewModel.selectedYear = 2023
        
        let expectedMonthCount = 12
        XCTAssertEqual(viewModel.months.count, expectedMonthCount)
    }
    
    func test_시작년도는_시작월부터_12월까지_나와야함() throws {
        let startDate = try XCTUnwrap(Calendar.current.date(from: DateComponents(year: 2023,
                                                                                 month: 3,
                                                                                 day: 1)))
        
        let endDate = try XCTUnwrap(Calendar.current.date(from: DateComponents(year: 2024,
                                                                               month: 4,
                                                                               day: 1)))
        
        let selectedDate = try XCTUnwrap(Calendar.current.date(from: DateComponents(year: 2023,
                                                                                    month: 4,
                                                                                    day: 1)))
        let dateRange = DateRange(startDate: startDate,
                                  endDate: endDate)
        
        let viewModel = MonthPickerViewModel(dateRange: dateRange, selectedDate: selectedDate)
        
        let expectedMonthCount = 10
        XCTAssertEqual(viewModel.months.count, expectedMonthCount)
    }
    
    func test_이전년도에서_올해로_연도를_돌리면_올해의_현재달까지_나와야함() throws {
        let startDate = try XCTUnwrap(Calendar.current.date(from: DateComponents(year: 2023,
                                                                                 month: 1,
                                                                                 day: 1)))
        
        let endDate = try XCTUnwrap(Calendar.current.date(from: DateComponents(year: 2024,
                                                                               month: 4,
                                                                               day: 1)))
        
        let selectedDate = try XCTUnwrap(Calendar.current.date(from: DateComponents(year: 2023,
                                                                                    month: 3,
                                                                                    day: 1)))
        let dateRange = DateRange(startDate: startDate,
                                  endDate: endDate)
        
        let viewModel = MonthPickerViewModel(dateRange: dateRange, selectedDate: selectedDate)
        viewModel.selectedYear = 2024
        
        let expectedMonthCount = 4
        XCTAssertEqual(viewModel.months.count, expectedMonthCount)
    }
    
    func test_이전년도에서_올해로_연도를_돌릴때_아직_오지_않은_달인경우_현재달로_설정() throws {
        let startDate = try XCTUnwrap(Calendar.current.date(from: DateComponents(year: 2023,
                                                                                 month: 1,
                                                                                 day: 1)))
        
        let endDate = try XCTUnwrap(Calendar.current.date(from: DateComponents(year: 2024,
                                                                               month: 4,
                                                                               day: 1)))
        
        let selectedDate = try XCTUnwrap(Calendar.current.date(from: DateComponents(year: 2023,
                                                                                    month: 5,
                                                                                    day: 1)))
        let dateRange = DateRange(startDate: startDate,
                                  endDate: endDate)
        
        let viewModel = MonthPickerViewModel(dateRange: dateRange, selectedDate: selectedDate)
        viewModel.selectedYear = 2024
        
        let expectedMonthCount = 4
        let expectedSelectedMonth = 4
        
        XCTAssertEqual(viewModel.months.count, expectedMonthCount)
        XCTAssertEqual(try XCTUnwrap(viewModel.selectedMonth), expectedSelectedMonth)
    }
    
    func test_pickedMonth() throws {
        let startDate = try XCTUnwrap(Calendar.current.date(from: DateComponents(year: 2023,
                                                                                 month: 1,
                                                                                 day: 1)))
        
        let endDate = try XCTUnwrap(Calendar.current.date(from: DateComponents(year: 2024,
                                                                               month: 4,
                                                                               day: 1)))
        
        let selectedDate = try XCTUnwrap(Calendar.current.date(from: DateComponents(year: 2023,
                                                                                    month: 5,
                                                                                    day: 1)))
        let dateRange = DateRange(startDate: startDate,
                                  endDate: endDate)
        
        let viewModel = MonthPickerViewModel(dateRange: dateRange, selectedDate: selectedDate)
        let expectedDate = try XCTUnwrap(Calendar.current.date(from: DateComponents(year: 2023,
                                                                                    month: 5,
                                                                                    day: 1)))
        
        XCTAssertEqual(viewModel.pickedMonth(), expectedDate)
        
        viewModel.selectedYear = 2024
        viewModel.selectedMonth = 3
        
        let expectedDate2 = try XCTUnwrap(Calendar.current.date(from: DateComponents(year: 2024,
                                                                                     month: 3,
                                                                                     day: 1)))
        XCTAssertEqual(viewModel.pickedMonth(), expectedDate2)
    }
}
