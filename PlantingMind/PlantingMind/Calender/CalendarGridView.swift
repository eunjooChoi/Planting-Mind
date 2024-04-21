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
        LazyVGrid(columns: Array(repeating: GridItem(), count: weekdays), spacing: 20, content: {
            let daysCount = viewModel.days.count
            ForEach(0..<daysCount, id:\.self) {idx in
                if let item = viewModel.days[idx] {
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
        .gesture(DragGesture(minimumDistance: 10, coordinateSpace: .local)
                    .onEnded { value in
                        let horizontalAmount = value.translation.width
                        let verticalAmount = value.translation.height
                        
                        guard abs(horizontalAmount) > abs(verticalAmount) else { return }
                        let addingValue = horizontalAmount < 0 ? 1 : -1
                        viewModel.addingMonth(value: addingValue)
                    })
    }
}

#Preview {
    CalendarGridView()
        .environmentObject(CalendarViewModel(today: Date(), context: CoreDataStack(.inMemory).persistentContainer.viewContext))
    
}
