//
//  CalendarView.swift
//  PlantingMind
//
//  Created by 최은주 on 1/22/24.
//

import SwiftUI

struct CalendarView: View {
    @Environment(\.scenePhase) var phase
    @StateObject var calendarViewModel: CalendarViewModel
    
    var body: some View {
        VStack {
            CalendarHeaderView()
            CalendarGridView()
            Spacer()
        }
        .environmentObject(calendarViewModel)
        .onChange(of: phase) { newValue in
            if newValue == .active {
                calendarViewModel.checkDate(date: Date())
            }
        }
    }
}

#Preview {
    CalendarView(calendarViewModel: CalendarViewModel(today: Date(), context: CoreDataStack(.inMemory).persistentContainer.viewContext))
}
