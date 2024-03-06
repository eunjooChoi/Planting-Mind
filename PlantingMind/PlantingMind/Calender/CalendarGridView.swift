//
//  CalendarGridView.swift
//  PlantingMind
//
//  Created by 최은주 on 1/19/24.
//

import SwiftUI

struct CalendarGridView: View {
    @EnvironmentObject var calendarViewModel: CalendarViewModel
    private let weekdays = 7
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(), count: weekdays), content: {
            ForEach(calendarViewModel.days, id: \.self) { item in
                if let item = item {
                    DayCellView(calendarModel: item)
                } else {
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundColor(Color.clear)
                }
            }
        })
        .onAppear(perform: {
            // TODO: Call calendarViewModel.fetch
        })
    }
}

#Preview {
    CalendarGridView()
        .environmentObject(CalendarViewModel(today: Date(), context: CoreDataStack(.inMemory).persistentContainer.viewContext))
    
}
