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
        ScrollView {
            VStack() {
                CalendarHeaderView()
                CalendarGridView()
                Divider()
                    .overlay(Color.Custom.line)
                
                AnalysisView(viewModel: AnalysisViewModel(moods: calendarViewModel.moods))
                Spacer()
            }
        }
        .environmentObject(calendarViewModel)
        .onChange(of: phase) { newValue in
            if newValue == .active {
                calendarViewModel.checkDate(date: Date())
            }
        }
        .alert("error_description", isPresented: $calendarViewModel.showErrorAlert) {
            Button("ok", role: .cancel) { }
        }
    }
}

#Preview {
    CalendarView(calendarViewModel: CalendarViewModel(today: Date(), context: CoreDataStack(.inMemory).persistentContainer.viewContext))
}
