//
//  MonthPickerViewModel.swift
//  PlantingMind
//
//  Created by 최은주 on 3/13/24.
//

import Foundation
import Combine

struct DateRange {
    let startDate: Date
    let endDate: Date
}

fileprivate struct YearMonth {
    let year: Int?
    let month: Int?
}

class MonthPickerViewModel: ObservableObject {
    private let startDate: YearMonth
    private let endDate: YearMonth
    private var cancellables: Set<AnyCancellable>
    private(set) var years: [Int] = []
    @Published var months: [Int] = []
    @Published var selectedYear: Int
    @Published var selectedMonth: Int
    
    init(dateRange: DateRange, selectedDate: Date) {
        let calendar = Calendar.current
        self.cancellables = []
        
        let startMonthComponent = calendar.dateComponents([.year, .month], from: dateRange.startDate)
        self.startDate = YearMonth(year: startMonthComponent.year, month: startMonthComponent.month)
        
        let endMonthComponent = calendar.dateComponents([.year, .month], from: dateRange.endDate)
        self.endDate = YearMonth(year: endMonthComponent.year, month: endMonthComponent.month)
        
        let selectedDateComponent = calendar.dateComponents([.year, .month], from: selectedDate)
        self.selectedYear = selectedDateComponent.year ?? 2024
        self.selectedMonth = selectedDateComponent.month ?? 1
        
        self.setupYearPicker()
        
        self.$selectedYear
            .sink {[weak self] year in
                self?.verify(year: year)
            }
            .store(in: &cancellables)
    }
    
    func setupYearPicker() {
        self.years.removeAll()
        
        guard let startYear = self.startDate.year,
              let endYear = self.endDate.year else { return }
        
        for year in startYear...endYear {
            self.years.append(year)
        }
    }
    
    func updateMonthPicker(year: Int?) {
        self.months.removeAll()
        
        guard let startYear = self.startDate.year,
              let startMonth = self.startDate.month,
              let endYear = self.endDate.year,
              let endMonth = self.endDate.month else { return }
        
        let monthRange: ClosedRange<Int>
        
        if year == endYear {
            monthRange = 1...endMonth
        } else if year == startYear {
            monthRange = startMonth...12
        } else {
            monthRange = 1...12
        }
        
        for month in monthRange {
            self.months.append(month)
        }
    }
    
    func verify(year: Int?) {
        self.updateMonthPicker(year: year)
        
        if year == self.years.last,
           self.selectedMonth > self.months.count {
            self.selectedMonth = self.months.count
        }
    }
    
    func pickedMonth() -> Date {
        return Calendar.current.date(from: DateComponents(year: self.selectedYear,
                                                          month: self.selectedMonth)) ?? Date()
    }
}
