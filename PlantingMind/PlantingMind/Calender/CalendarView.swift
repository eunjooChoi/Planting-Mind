//
//  CalendarView.swift
//  PlantingMind
//
//  Created by 최은주 on 1/22/24.
//

import SwiftUI

struct CalendarView: View {
    @StateObject var calendarViewModel: CalendarViewModel
    
    var body: some View {
        VStack {
            CalendarHeaderView()
            CalendarGridView()
            Spacer()
        }
        .environmentObject(calendarViewModel)
    }
}

#Preview {
    CalendarView(calendarViewModel: CalendarViewModel(today: Date(), context: CoreDataStack(.inMemory).persistentContainer.viewContext))
}
