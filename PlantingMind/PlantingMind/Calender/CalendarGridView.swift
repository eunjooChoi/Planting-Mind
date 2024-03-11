//
//  CalendarGridView.swift
//  PlantingMind
//
//  Created by 최은주 on 1/19/24.
//

import SwiftUI

struct CalendarGridView: View {
    @EnvironmentObject var viewModel: CalendarViewModel
    private let weekdays = 7
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(), count: weekdays), content: {
            ForEach(viewModel.days, id: \.self) { item in
                if let item = item {
                    let moodRecord = viewModel.mood(of: item)
                    DayCellView(viewModel: DayCellViewModel(today: viewModel.today, calendarModel: item, moodRecord: moodRecord))
                } else {
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundColor(Color.clear)
                }
            }
        })
        .onAppear(perform: {
            viewModel.fetch()
        })
    }
}

#Preview {
    CalendarGridView()
        .environmentObject(CalendarViewModel(today: Date(), context: CoreDataStack(.inMemory).persistentContainer.viewContext))
    
}
