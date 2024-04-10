//
//  CalendarViewModel.swift
//  PlantingMind
//
//  Created by 최은주 on 1/22/24.
//

import Foundation
import CoreData
import Combine

class CalendarViewModel: ObservableObject {
    let context: NSManagedObjectContext
    private(set) var today: Date
    private var cancellables: Set<AnyCancellable>
    
    private var calendar: Calendar {
        Calendar.current
    }
    
    @Published var selectedDate: Date
    @Published var days: [CalendarModel?] = []
    @Published var moods: [MoodRecord] = []
    
    let weekdaySymbols = Calendar.current.veryShortWeekdaySymbols
    let startMonth: Date? = Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 1))
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy. MM"
        return formatter
    }()
    
    init(today: Date, context: NSManagedObjectContext) {
        self.cancellables = []
        self.today = today
        self.selectedDate = today
        self.context = context
        self.bindFetchNotification()
        
        self.$selectedDate
            .sink {[weak self] date in
                self?.updateDays(with: date)
                self?.fetch(date: date)
            }
            .store(in: &cancellables)
    }
    
    func addingMonth(value: Int) {
        guard let newMonth = self.calendar.date(byAdding: .month, value: value, to: selectedDate),
              let startMonth = self.startMonth else { return }
        
        // newMonth가 2024년 1월 이전이라면 return
        guard newMonth >= startMonth else { return }
        
        // newMonth가 today보다 다음 달이라면 return
        guard newMonth <= today else { return }
        
        selectedDate = newMonth
    }
    
    func fetch() {
        self.fetch(date: self.selectedDate)
    }
    
    private func fetch(date: Date) {
        guard let startOfMonth = date.startOfMonth,
              let endOfMonth = date.endOfMonth else { return }
        
        let fetchRequest = NSFetchRequest<MoodRecord>(entityName: "MoodRecord")
        let predicate = NSPredicate(format: "%K >= %@ && %K <= %@", #keyPath(MoodRecord.timestamp), startOfMonth as NSDate, #keyPath(MoodRecord.timestamp), endOfMonth as NSDate)
        fetchRequest.predicate = predicate
        
        do {
            let result = try context.fetch(fetchRequest)
            self.moods = result
            
        } catch {
            print("Failed to fetch the mood records", error.localizedDescription)
        }
    }
    
    func mood(of day: CalendarModel) -> MoodRecord? {
        guard let date = self.calendar.date(from: DateComponents(year: day.year,
                                                                    month: day.month,
                                                                    day: day.day)) else { return nil }
        
        return self.moods.filter { $0.timestamp == date }.first
    }
    
    func checkDate(date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let currentToday = dateFormatter.string(from: self.today)
        let currentDate = dateFormatter.string(from: date)
        
        if currentToday != currentDate {
            self.today = date
            self.selectedDate = today
        }
    }
    
    private func daysCount(for month: Date) -> Int {
        return self.calendar.range(of: .day, in: .month, for: month)?.count ?? 0
    }
    
    private func firstDay(date: Date) -> Int {
        let components = self.calendar.dateComponents([.year, .month], from: date)
        let firstDayOfMonth = self.calendar.date(from: components)!
        
        return self.calendar.component(.weekday, from: firstDayOfMonth) - 1
    }
    
    private func updateDays(with selectedDate: Date) {
        self.days.removeAll()
        
        let firstDay = self.firstDay(date: selectedDate)
        let daysCount = self.daysCount(for: selectedDate)
        
        for idx in (0 ..< daysCount + firstDay) {
            if idx < firstDay {
                self.days.append(nil)
            } else {
                let components = self.calendar.dateComponents([.year, .month], from: selectedDate)
                let day = idx - firstDay + 1
                if let date = self.calendar.date(from: DateComponents(year: components.year,
                                                              month: components.month,
                                                                      day: day)) {
                    let calendarModel = CalendarModel(year: components.year,
                                                      month: components.month,
                                                      day: day,
                                                      isToday: self.calendar.isDate(self.today, equalTo: date, toGranularity: .day))
                    self.days.append(calendarModel)
                } else {
                    self.days.append(nil)
                }
            }
        }
    }
    
    /**
     MoodRecordViewModel로부터 노티를 받아 Fetch 작업 수행
     */
    private func bindFetchNotification() {
        // TODO: 테스트가 아닌 실제 환경에서도 데이터 저장시 delay가 있는 경우가 있는지 확인 필요
        NotificationCenter.default.publisher(for: .fetchNotification)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.fetch()
            }
            .store(in: &cancellables)
    }
}
