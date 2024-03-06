//
//  CalendarViewModel.swift
//  PlantingMind
//
//  Created by 최은주 on 1/22/24.
//

import Foundation
import CoreData

class CalendarViewModel: ObservableObject {
    private let context: NSManagedObjectContext
    
    @Published var currentDate: Date
    @Published var days: [CalendarModel?] = []
    @Published var moods: [MoodRecord] = []
    
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
    
    init(today: Date, context: NSManagedObjectContext) {
        self.today = today
        self.currentDate = today
        self.context = context
        self.updateDays()
    }
    
    func addingMonth(value: Int) {
        guard let newMonth = calendar.date(byAdding: .month, value: value, to: currentDate) else {
            return
        }
        
        currentDate = newMonth
        updateDays()
    }
    
    func fetch() {
        var dateFormatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM"
            
            return formatter
        }
        
        let timestamp = dateFormatter.string(from: currentDate)
        
        let fetchRequest = NSFetchRequest<MoodRecord>(entityName: "MoodRecord")
        let predicate = NSPredicate(format: "%K CONTAINS[cd] %@", #keyPath(MoodRecord.timestamp), timestamp)
        fetchRequest.predicate = predicate
        
        do {
            let result = try context.fetch(fetchRequest)
            self.moods = result
            
        } catch {
            print("Failed to fetch the mood records", error.localizedDescription)
        }
    }
    
    func mood(of day: CalendarModel) -> MoodRecord? {
        var dateFormatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            
            return formatter
        }
        
        guard let date = Calendar.current.date(from: DateComponents(year: day.year,
                                                                    month: day.month,
                                                                    day: day.day)) else { return nil }
        let timestamp = dateFormatter.string(from: date)
        
        return self.moods.filter { $0.timestamp == timestamp }.first
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
