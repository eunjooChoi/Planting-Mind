//
//  CalendarGridView.swift
//  PlantingMind
//
//  Created by 최은주 on 1/19/24.
//

import SwiftUI

struct CalendarGridView: View {
    @Binding var currentDate: Date
    private let weekdays = 7
    
    var body: some View {
        let daysOfMonth = numberOfDays()
        let firstWeekDay = firstWeekdayOfMonth(in: currentDate)
        
        LazyVGrid(columns: Array(repeating: GridItem(), count: weekdays), content: {
            ForEach(0 ..< daysOfMonth + firstWeekDay, id: \.self) { index in
                if index < firstWeekDay {
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundColor(Color.clear)
                } else {
                    DayCellView(day: String(index - firstWeekDay + 1))
                }
            }
        })
    }
    
    func numberOfDays() -> Int {
        return Calendar.current.range(of: .day, in: .month, for: currentDate)?.count ?? 0
    }
    
    func firstWeekdayOfMonth(in date: Date) -> Int {
        let components = Calendar.current.dateComponents([.year, .month], from: date)
        let firstDayOfMonth = Calendar.current.date(from: components)!
        
        return Calendar.current.component(.weekday, from: firstDayOfMonth) - 1
    }
}

struct CalendarGridView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarGridView(currentDate: .constant(Date()))
    }
}
