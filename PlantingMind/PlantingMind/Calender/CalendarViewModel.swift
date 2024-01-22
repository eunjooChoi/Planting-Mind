//
//  CalendarViewModel.swift
//  PlantingMind
//
//  Created by 최은주 on 1/22/24.
//

import Foundation

class CalendarViewModel: ObservableObject {
    @Published var currentDate: Date
    @Published var days: [CalendarModel?] = []
    
    private var today: Date
    
    private var calendar: Calendar {
        Calendar.current
    }
    
    let weekdaySymbols = Calendar.current.veryShortWeekdaySymbols
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy. MM"
        return formatter
    }()
    
    init(today: Date) {
        self.today = today
        self.currentDate = today
        updateDays()
    }
    
    func addingMonth(value: Int) {
        guard let newMonth = calendar.date(byAdding: .month, value: value, to: currentDate) else {
            return
        }
        
        currentDate = newMonth
        updateDays()
    }
    
    private func daysCount() -> Int {
        return Calendar.current.range(of: .day, in: .month, for: currentDate)?.count ?? 0
    }
    
    private func firstDay() -> Int {
        let components = Calendar.current.dateComponents([.year, .month], from: currentDate)
        let firstDayOfMonth = Calendar.current.date(from: components)!
        
        return Calendar.current.component(.weekday, from: firstDayOfMonth) - 1
    }
    
    private func updateDays() {
        days.removeAll()
        
        let firstDay = firstDay()
        let daysCount = daysCount()
        
        for idx in (0 ..< daysCount + firstDay) {
            if idx < firstDay {
                days.append(nil)
            } else {
                let components = calendar.dateComponents([.year, .month], from: currentDate)
                let day = idx - firstDay + 1
                let date = calendar.date(from: DateComponents(year: components.year,
                                                              month: components.month,
                                                              day: day))
                
                let calendarModel = CalendarModel(year: components.year,
                                                  month: components.month,
                                                  day: day,
                                                  isToday: calendar.isDate(today, equalTo: date!, toGranularity: .day))
                days.append(calendarModel)
            }
        }
    }
}
