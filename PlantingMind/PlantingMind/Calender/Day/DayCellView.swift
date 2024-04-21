//
//  DayCellView.swift
//  PlantingMind
//
//  Created by 최은주 on 1/19/24.
//

import SwiftUI

struct DayCellView: View {
    @Environment(\.managedObjectContext) var context
    @State var showMoodRecordView: Bool = false
    
    var viewModel: DayCellViewModel
    
    var body: some View {
        VStack(spacing: 1) {
            Button(action: {
                showMoodRecordView.toggle()
            }, label: {
                Text("\(viewModel.calendarModel.day)")
                    .frame(width: 25, height: 25)
                    .fontWeight(.semibold)
                    .background(viewModel.dayBackgroundColor)
                    .foregroundStyle(viewModel.dayForegroundColor)
                    .clipShape(.circle)
            })
            .frame(height: 27)
            .sheet(isPresented: $showMoodRecordView) {
                MoodRecordView(viewModel: MoodRecordViewModel(context: context,
                                                              calendarModel: viewModel.calendarModel,
                                                              moodRecord: viewModel.moodRecord))
                .interactiveDismissDisabled(true)
            }
            .disabled(viewModel.isFutureDate)
            
            RoundedRectangle(cornerRadius: 5)
                .frame(height: 15)
                .foregroundStyle(viewModel.moodForegroundColor)
                .overlay {
                    viewModel.moodEmoji
                }
        }
    }
}

#Preview {
    DayCellView(viewModel: DayCellViewModel(today: Date(), calendarModel: CalendarModel(year: 2024, month: 2, day: 24, isToday: true),
                                            moodRecord: MoodRecord(context: CoreDataStack(.inMemory).persistentContainer.viewContext)))
}
